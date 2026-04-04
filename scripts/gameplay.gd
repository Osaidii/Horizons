extends Node

func _ready() -> void:
	# Fixes for Resolution Updating
	get_viewport().size_changed.connect(_on_resize)
	Utilities.update_resolution()

func _on_resize() -> void:
	# Update Resolution
	Utilities.update_resolution()
