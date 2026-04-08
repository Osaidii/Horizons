extends Control

func _draw() -> void:
	# Draw Circle
	var center := get_viewport_rect().end / 2
	draw_circle(center, 2, Color.WHITE, true, -1, true)
