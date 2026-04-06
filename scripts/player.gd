class_name Player
extends CharacterBody3D

@export_category("Simple")
@export var SPEED := 4.0
@export var CROUCH_SPEED := 2.2
@export var SENSITIVITY := 0.003
@export_category("Head Bob")
@export var BOB_FREQ := 2.2
@export var BOB_AMP := 0.08
@export_category("Enables")
@export var FLASH_LIGHT_UNLOCKED := true
@export var DISABLE_CRT_SHADER := false
@export_category("Shader")
@export var curvature = 6.0
@export var blur = 0.1
@export var line_alpha = 0.1
@export var line_subtleness = 1.0
@export var vignette_multiplier = 0.6
@export var vignette_border := 7.0
@export_category("Flash Light")
@export var ENERGY := 5
@export var SECONDS_PER_BATTERY_BAR := 20
@export var START_BATTERY := 12
@export var MAX_BATTERY := 36
@export var WAIT_TIME := 1
@export var TRANSITION_TIME := 0.7


@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction_checker: RayCast3D = $"Head/Camera3D/Interaction Checker"
@onready var crosshair: Control = $HUD/Crosshair
@onready var simple_animations: AnimationPlayer = $"Simple Animations"
@onready var crouch_check: RayCast3D = $"Crouch Check"
@onready var pick_up_instruction: RichTextLabel = $"HUD/Pick Up Instruction"
@onready var interact_instruction: RichTextLabel = $"HUD/Interact Instruction"

var t_bob := 0.0
var is_crouching := false
var current_speed: float
var direction: Vector3

# Private Funcs

func _ready() -> void:
	# No Mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Set Speed
	current_speed = SPEED

func _input(event: InputEvent) -> void:
	# Camera System
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	# Crouch Input
	if event.is_action_pressed("crouch") and !is_crouching:
		crouch(true)
	elif event.is_action_pressed("crouch") and is_crouching:
		crouch(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Movement System
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length() > 0:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 7.0)
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# Check for Interaction
	_interact()
	
	# Move Player
	move_and_slide()

func _headbob(time) -> Vector3:
	# Headbob Up and Down
	var pos := Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func _interact_check(provided_collision):
	# Check for Crosshair on Interactable
	var current_check = provided_collision
	for i in range(5):
		if current_check == null:
			break
		if current_check is Interactable:
			return [true, current_check]
		current_check = current_check.get_parent()
	return [false, current_check]

func _pickable_check(provided_collision):
	# Check for Crosshair on Pickable
	var current_check = provided_collision
	for i in range(5):
		if current_check == null:
			break
		if current_check is Pickable:
			return [true, current_check]
		current_check = current_check.get_parent()
	return [false, current_check]

func _interact() -> void:
	# Send Signal if Interactable
	if interaction_checker.is_colliding():
		
		# Check if Node if Pickable or Interactable
		var target := interaction_checker.get_collider()
		var pick_answer_array = _pickable_check(target)
		var is_pickable: bool = pick_answer_array[0]
		var node_that_is_pickable = pick_answer_array[1]
		var is_interactable: bool
		var node_that_is_interactable
		if !is_pickable:
			var interact_answer_array: Array = _interact_check(target)
			is_interactable = interact_answer_array[0]
			node_that_is_interactable = interact_answer_array[1]
		
		# Instructions
		pick_up_instruction.visible = is_pickable
		interact_instruction.visible = is_interactable
		
		# Trigger Interaction
		if is_pickable:
			if Input.is_action_pressed("interact"):
				node_that_is_pickable._pick()
		if is_interactable:
			if Input.is_action_pressed("interact"):
				node_that_is_interactable._interact()
	else:
		pick_up_instruction.visible = false
		interact_instruction.visible = false

# Public Funcs

func crouch(crouch_state) -> void:
	# Crocu and Uncrouch
	if crouch_state == true:
		simple_animations.play("Crouch")
		is_crouching = true
		await get_tree().create_timer(0.2).timeout
		current_speed = CROUCH_SPEED
	else:
		if crouch_check.is_colliding():
			return
		simple_animations.play_backwards("Crouch")
		await get_tree().create_timer(0.2).timeout
		current_speed = SPEED
		is_crouching = false
