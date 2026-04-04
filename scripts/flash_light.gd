class_name Flashlight
extends Node3D

@export_category("Data")
@export var ENERGY := 5
@export var SECONDS_PER_BATTERY_BAR := 20
@export var START_BATTERY := 12
@export var MAX_BATTERY := 36
@export var WAIT_TIME := 1
@export var TRANSITION_TIME := 0.7
@export_category("Normal Transform")
@export var NORMAL_POSITION := Vector3.ZERO
@export_category("Rest Transform")
@export var REST_POSITION := Vector3.ZERO
@export_category("External")
@export var BATTERY := 14

@onready var light: SpotLight3D = $Light
@onready var mesh: Node3D = $Mesh
@onready var wait_timer: Timer = $"Wait Time"
@onready var button_sound: AudioStreamPlayer3D = $"Button Sound"
@onready var battery_decrease_timer: Timer = $"Battery Decrease Timer"

var is_light_on := false

# Private Funcs

func _ready() -> void:
	# Set Position
	position = REST_POSITION
	# Set Light
	light.light_energy = 0
	# Wait Timer
	wait_timer.wait_time = WAIT_TIME
	# Set Battery
	BATTERY = START_BATTERY

func _input(event: InputEvent) -> void:
	# Turn Light On
	if event.is_action_pressed("flashlight") and is_light_on and wait_timer.is_stopped():
		turn_light_off()
	# Turn Light Off
	elif event.is_action_pressed("flashlight") and !is_light_on and wait_timer.is_stopped():
		turn_light_on()

func _process(delta: float) -> void:
	# Battery ON / OFF Logic
	if light.light_energy == ENERGY:
		is_light_on = true
	elif light.light_energy == 0:
		is_light_on = false
	
	# Increase Battery
	if Shortcuts.increase_flashlight_battery > 0:
		increase_battery(Shortcuts.increase_flashlight_battery)
		Shortcuts.increase_flashlight_battery = 0
	
	# Max and Min Battery
	BATTERY = clamp(BATTERY, MAX_BATTERY, 0)
	
	# Decrease Battery
	if battery_decrease_timer.is_stopped():
		battery_decrease_timer.wait_time = SECONDS_PER_BATTERY_BAR
		battery_decrease_timer.start() 

# Public Funcs

func turn_light_on() -> void:
	# Tween for Up and Down
	var tween = create_tween()
	tween.tween_property(self, "position", NORMAL_POSITION + Vector3(0, 0.02, 0), TRANSITION_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", NORMAL_POSITION, TRANSITION_TIME * 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	wait_timer.start()
	await get_tree().create_timer(TRANSITION_TIME / 2).timeout
	# Turn Light On
	button_sound.play()
	light.light_energy = ENERGY
	is_light_on = true

func turn_light_off() -> void:
	wait_timer.start()
	# Tween for Up and Down
	var tween = create_tween()
	tween.tween_property(self, "position", REST_POSITION, TRANSITION_TIME * 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# Turn Light Off
	await get_tree().create_timer(0.1).timeout
	button_sound.play()
	await get_tree().create_timer(0.1).timeout
	light.light_energy = 0
	is_light_on = false

func increase_battery(increase) -> void:
	# Increase Battery
	BATTERY += increase
