class_name Flashlight
extends Node3D

@export_category("Normal Transform")
@export var NORMAL_POSITION := Vector3.ZERO
@export_category("Rest Transform")
@export var REST_POSITION := Vector3.ZERO

@onready var light: SpotLight3D = $Light
@onready var mesh: Node3D = $Mesh
@onready var wait_timer: Timer = $"Wait Time"
@onready var button_sound: AudioStreamPlayer3D = $"Button Sound"
@onready var simple_animations: AnimationPlayer = $"../../../Simple Animations"
@onready var player: Player = $"../../.."

var is_light_on := false
var decrease_time := 0.0
var BATTERY := 0

# Private Funcs

func _ready() -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Set Position
	position = REST_POSITION
	# Set Light
	light.light_energy = 0
	# Wait Timer
	wait_timer.wait_time = player.WAIT_TIME
	# Set Battery
	BATTERY = player.START_BATTERY
	decrease_time = player.SECONDS_PER_BATTERY_BAR

func _input(event: InputEvent) -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Turn Light On
	if event.is_action_pressed("flashlight") and is_light_on and wait_timer.is_stopped():
		turn_light_off()
	# Turn Light Off
	elif event.is_action_pressed("flashlight") and !is_light_on and wait_timer.is_stopped():
		turn_light_on()

func _process(delta: float) -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Battery ON / OFF Logic
	if light.light_energy == player.ENERGY:
		is_light_on = true
	elif light.light_energy == 0:
		is_light_on = false
	
	# Increase Battery
	if Shortcuts.increase_flashlight_battery > 0:
		increase_battery(Shortcuts.increase_flashlight_battery)
		Shortcuts.increase_flashlight_battery = 0
	
	# Max and Min Battery
	BATTERY = clamp(BATTERY, 0, player.MAX_BATTERY)
	
	# Decrease Battery Logic
	if is_light_on:
		if decrease_time <= 0.0:
			decrease_time = player.SECONDS_PER_BATTERY_BAR
			BATTERY -= 1
		else:
			decrease_time -= delta

# Public Funcs

func turn_light_on() -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Tween for Up and Down
	var tween := create_tween()
	tween.tween_property(self, "position", NORMAL_POSITION + Vector3(0, 0.02, 0), player.TRANSITION_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", NORMAL_POSITION, player.TRANSITION_TIME * 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	wait_timer.start()
	await get_tree().create_timer(player.TRANSITION_TIME / 2).timeout
	# Turn Light On
	simple_animations.play("Light Button Click")
	button_sound.play()
	light.light_energy = player.ENERGY
	is_light_on = true

func turn_light_off() -> void:
	if !Shortcuts.flash_light_unlocked: return
	wait_timer.start()
	# Tween for Up and Down
	var tween := create_tween()
	tween.tween_property(self, "position", REST_POSITION, player.TRANSITION_TIME * 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# Turn Light Off
	await get_tree().create_timer(0.1).timeout
	simple_animations.play("Light Button Click")
	button_sound.play()
	await get_tree().create_timer(0.1).timeout
	light.light_energy = 0
	is_light_on = false

func increase_battery(increase) -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Increase Battery
	BATTERY += increase
