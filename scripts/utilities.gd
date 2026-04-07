extends Node

func for_correct_resolution(number) -> float:
	# Design to Current Resolution
	var answer: float = number / Shortcuts.design_resolution.y * Shortcuts.current_resolution.y
	return answer

func update_resolution():
	# Update Current Resolution
	Shortcuts.current_resolution = get_viewport().get_visible_rect().size
