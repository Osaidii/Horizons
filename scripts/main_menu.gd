extends Control

const INTRO = preload("res://scenes/intro.scn") as PackedScene

const DOMAIN_1 = preload("res://scenes/domain_1.tscn") as PackedScene

const DOMAIN_2 = preload("res://scenes/domain_2.tscn") as PackedScene

const DOMAIN_3 = preload("res://scenes/domain_3.tscn") as PackedScene

const CREDITS = preload("res://ui/credits.tscn") as PackedScene

# For Debugging, Buttons to go all scenes, hehe boi! work smart not hard!

func _on_intro_pressed() -> void:
	get_tree().change_scene_to_packed(INTRO)

func _on_domain_1_pressed() -> void:
	get_tree().change_scene_to_packed(DOMAIN_1)

func _on_domain_2_pressed() -> void:
	get_tree().change_scene_to_packed(DOMAIN_2)

func _on_domain_3_pressed() -> void:
	get_tree().change_scene_to_packed(DOMAIN_3)

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)
