class_name Battery
extends Interactable

func _interact():
	# Emit and Leave
	Shortcuts.increase_flashlight_battery = 4
	queue_free()
