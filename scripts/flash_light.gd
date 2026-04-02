
extends Node3D

@export_category("Data")
@export var ENERGY := 5
@export var BATTERY_DRAIN_PER_SECOND := 10
@export var SWAY_MIN := Vector2(-20, -20)
@export var SWAY_MAX := Vector2(20, 20)
@export var SWAY_SPEED := 0.9
@export var SWAY_POSITION := 0.5
@export var SWAY_ROTATION := 10
@export var SWAY_NOISE: FastNoiseLite

@onready var light: SpotLight3D = $Light
@onready var mesh: Node3D = $Mesh

var is_light_on := false
var battery: float
var mouse_movement: Vector2
var start_pos: Vector3
var start_rot: Vector3

# Private Funcs

func _ready() -> void:
	light.light_energy = 0
	battery = 100
	start_pos = position
	start_rot = rotation_degrees

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight") and is_light_on:
		turn_light_off()
	elif event.is_action_pressed("flashlight") and !is_light_on:
		turn_light_on()
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func _process(delta: float) -> void:
	if light.light_energy == ENERGY:
		is_light_on = true
	elif light.light_energy == 0:
		is_light_on = false
	if battery <= 0:
		turn_light_off()
		battery = clamp(battery, 0, 100)
	if is_light_on:
		battery -= BATTERY_DRAIN_PER_SECOND * delta
	_sway_weapon(delta)

func _sway_weapon(delta) -> void:
	var smoothed_mouse_movement := Vector2.ZERO
	mouse_movement = mouse_movement.clamp(SWAY_MIN, SWAY_MAX)
	smoothed_mouse_movement = smoothed_mouse_movement.lerp(mouse_movement, 12 * delta)
	position.x = lerp(position.x, start_pos.x - (smoothed_mouse_movement.x * SWAY_POSITION) * delta, SWAY_SPEED)
	position.y = lerp(position.y, start_pos.y + (smoothed_mouse_movement.y * SWAY_POSITION) * delta, SWAY_SPEED)
	rotation_degrees.x = lerp(rotation_degrees.x, start_rot.x - (smoothed_mouse_movement.y * SWAY_ROTATION) * delta, SWAY_SPEED)
	rotation_degrees.y = lerp(rotation_degrees.y, start_rot.y + (smoothed_mouse_movement.x * SWAY_ROTATION) * delta, SWAY_SPEED)

# Public Funcs

func turn_light_on() -> void:
	light.light_energy = ENERGY
	is_light_on = true

func turn_light_off() -> void:
	light.light_energy = 0
	is_light_on = false
