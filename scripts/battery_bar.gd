extends Control

@onready var flash_light: Flashlight = $"../../Head/Camera3D/FlashLight"

func _ready() -> void:
	_number_to_output(flash_light.START_BATTERY)

func _process(delta: float) -> void:
	_number_to_output(flash_light.BATTERY)

func _number_to_output(bars) -> void:
	var complete_bars = floor(flash_light.BATTERY / 4)
	var rest = flash_light.BATTERY % 4
	if complete_bars > 0:
		for i in range(complete_bars):
			get_child(i).get_child(3).visible = true
	if rest > 0:
		get_child(complete_bars).get_child(rest - 1).visible = true
	if complete_bars == 0 and rest == 0:
		get_child(1).visible = true
