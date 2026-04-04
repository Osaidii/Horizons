extends Control

@onready var flash_light: Flashlight = $"../../Head/Camera3D/FlashLight"

func _ready() -> void:
	if !GlobalVariables.flash_light_unlocked: return
	# Set Starting Postions and Values
	_number_to_output()
	_set_position_on_screen()

func _process(_delta: float) -> void:
	if !GlobalVariables.flash_light_unlocked: return
	# Set Battery as Correct
	_number_to_output()

func _set_position_on_screen() -> void:
	if !GlobalVariables.flash_light_unlocked: return
	# Set Correct Postions in Relevance to Resolution
	for i in range(9):
		var current_node := get_child(i)
		for j in current_node.get_children():
			j.position.x = Utilities.for_correct_resolution(25) + (Utilities.for_correct_resolution(40) * i)
			j.position.y = get_viewport_rect().end.y - Utilities.for_correct_resolution(30)
			j.scale.x = Utilities.for_correct_resolution(0.1)
			j.scale.y = Utilities.for_correct_resolution(0.1)

func _number_to_output() -> void:
	if !GlobalVariables.flash_light_unlocked: return
	# Show Battery Remaining
	var complete_bars = floor(flash_light.BATTERY / 4)
	var rest = flash_light.BATTERY % 4
	if complete_bars > 0:
		for i in range(complete_bars):
			get_child(i).get_child(3).visible = true
	if rest > 0:
		get_child(complete_bars).get_child(rest - 1).visible = true
	if complete_bars == 0 and rest == 0:
		get_child(1).visible = true
