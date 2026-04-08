extends Node3D

const DOMAIN_1 = preload("res://scenes/domain_1.tscn") as PackedScene

func _on_cutscene_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cutscene":
		get_tree().change_scene_to_packed(DOMAIN_1)
