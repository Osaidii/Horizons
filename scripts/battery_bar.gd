extends Control

@onready var flash_light: Flashlight = $"../../Head/Camera3D/FlashLight"

@export var BAR_SCALE := 0.075
@export var X_OFFSET := 25
@export var Y_OFFSET := 30
@export var DIFFERENCE_OFFSET := 40

var previous_battery := 0

func _ready() -> void:
	if !Shortcuts.flash_light_unlocked: return
	
	previous_battery = flash_light.BATTERY
	_number_to_output()
	_set_position_on_screen()

func _process(_delta: float) -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Set Battery as Correct
	if flash_light.BATTERY != previous_battery:
		previous_battery = flash_light.BATTERY
		_clear_bars()
		_number_to_output()

func _clear_bars() -> void:
	for i in range(9):
		var bar = get_child(i)
		for j in bar.get_children():
			j.visible = false

func _set_position_on_screen() -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Set Correct Postions in Relevance to Resolution
	for i in range(9):
		var current_node := get_child(i)
		for j in current_node.get_children():
			j.scale.x = Utilities.for_correct_resolution(BAR_SCALE)
			j.scale.y = Utilities.for_correct_resolution(BAR_SCALE)
			j.position.x = Utilities.for_correct_resolution(X_OFFSET * (BAR_SCALE * 10)) + (Utilities.for_correct_resolution(DIFFERENCE_OFFSET * (BAR_SCALE * 10)) * i)
			j.position.y = get_viewport_rect().end.y - Utilities.for_correct_resolution(Y_OFFSET * (BAR_SCALE * 10))

func _number_to_output() -> void:
	if !Shortcuts.flash_light_unlocked: return
	# Show Battery Remaining
	var complete_bars: int = floor(flash_light.BATTERY / 4)
	var rest: int = flash_light.BATTERY % 4
	if complete_bars > 0:
		for i in range(complete_bars):
			get_child(i).get_child(3).visible = true
	if rest > 0:
		get_child(complete_bars).get_child(rest - 1).visible = true
	if complete_bars == 0 and rest == 0:
		get_child(1).visible = true
