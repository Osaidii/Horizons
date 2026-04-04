class_name Battery
extends Interactable

@onready var flash_light: Flashlight = $Head/Camera3D/FlashLight

func _interact():
	# Emit and Leave
	Shortcuts.increase_flashlight_battery = 4
	queue_free()
