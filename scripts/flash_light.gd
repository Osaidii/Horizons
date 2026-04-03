class_name Flashlight
extends Node3D

@export_category("Data")
@export var ENERGY := 5
@export var BATTERY_DRAIN_PER_SECOND := 1
@export var WAIT_TIME := 1
@export var TRANSITION_TIME := 0.7
@export_category("Normal Transform")
@export var NORMAL_POSITION := Vector3.ZERO
@export_category("Rest Transform")
@export var REST_POSITION := Vector3.ZERO
@export_category("Vars for external use")
@export var battery: float

@onready var light: SpotLight3D = $Light
@onready var mesh: Node3D = $Mesh
@onready var wait_timer: Timer = $"Wait Time"
@onready var button_sound: AudioStreamPlayer3D = $"Button Sound"
@onready var bar: ProgressBar = $"../../../HUD/BatteryBar/Bar"

var is_light_on := false

# Private Funcs

func _ready() -> void:
	position = REST_POSITION
	light.light_energy = 0
	battery = 100
	
	wait_timer.wait_time = WAIT_TIME

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight") and is_light_on and wait_timer.is_stopped():
		turn_light_off()
	elif event.is_action_pressed("flashlight") and !is_light_on and wait_timer.is_stopped():
		turn_light_on()

func _process(delta: float) -> void:
	# Battery ON / OFF Logic
	if light.light_energy == ENERGY:
		is_light_on = true
	elif light.light_energy == 0:
		is_light_on = false
	
	# Battery Logic
	if battery <= 0:
		turn_light_off()
		battery = clamp(battery, 0, 100)
	if is_light_on:
		battery -= BATTERY_DRAIN_PER_SECOND * delta
	
	# Bar Logic
	bar.value = battery
	

# Public Funcs

func turn_light_on() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", NORMAL_POSITION + Vector3(0, 0.02, 0), TRANSITION_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", NORMAL_POSITION, TRANSITION_TIME * 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	wait_timer.start()
	await get_tree().create_timer(TRANSITION_TIME / 2).timeout
	button_sound.play()
	light.light_energy = ENERGY
	is_light_on = true

func turn_light_off() -> void:
	wait_timer.start()
	var tween = create_tween()
	tween.tween_property(self, "position", REST_POSITION, TRANSITION_TIME * 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.1).timeout
	button_sound.play()
	await get_tree().create_timer(0.1).timeout
	light.light_energy = 0
	is_light_on = false
