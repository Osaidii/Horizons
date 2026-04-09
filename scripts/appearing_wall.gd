extends Node3D

@onready var collision: CollisionShape3D = $Static/Collision
@onready var meshes: Node3D = $Meshes

var walked_trough: bool
var not_on_screen: bool

func _not_on_screen() -> void:
	not_on_screen = true

func _on_area_body_exited(body: Node3D) -> void:
	if body is Player:
		walked_trough = true
	if walked_trough and not_on_screen:
		collision.disabled = false
		meshes.visible = true

func _on_screen() -> void:
	not_on_screen = false
