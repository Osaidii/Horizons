class_name Player
extends CharacterBody3D

@export_category("Simple")
@export var SPEED := 4.0
@export var CROUCH_SPEED := 2.2
@export var SENSITIVITY := 0.003
@export_category("HEAD BOB")
@export var BOB_FREQ := 2.2
@export var BOB_AMP := 0.08

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction_checker: RayCast3D = $"Head/Camera3D/Interaction Checker"
@onready var crosshair: Control = $HUD/Crosshair
@onready var simple_animations: AnimationPlayer = $"Simple Animations"
@onready var crouch_check: RayCast3D = $"Crouch Check"

var t_bob := 0.0
var is_crouching := false
var current_speed: float

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
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length() > 0:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 7.0)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# Interaction System
	if interaction_checker.is_colliding():
		var target = interaction_checker.get_collider()
		var is_interactable = _interact_check(target)
		
		# Continue Signals HERE !!!!!!!!!!!!!!
	
	move_and_slide()

func _headbob(time) -> Vector3:
	# Headbob System
	var pos := Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func _interact_check(provided_collision) -> bool:
	var current_check = provided_collision
	for i in range(5):
		if current_check == null:
			break
		if current_check is Interactable:
			return true
		current_check = current_check.get_parent()
	return false

# Public Funcs

func crouch(state) -> void:
	if state == true:
		current_speed = CROUCH_SPEED
		simple_animations.play("crouch")
		is_crouching = true
	else:
		if crouch_check.is_colliding():
			return
		current_speed = SPEED
		simple_animations.play_backwards("crouch")
		is_crouching = false
		
