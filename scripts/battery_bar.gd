extends Control

@onready var _1: Control = $"1"
@onready var _2: Control = $"2"
@onready var _3: Control = $"3"
@onready var _4: Control = $"4"
@onready var _5: Control = $"5"
@onready var _6: Control = $"6"
@onready var _7: Control = $"7"
@onready var _8: Control = $"8"
@onready var _9: Control = $"9"

func _ready() -> void:
	_1.get_child(3).visible = true
	_2.get_child(3).visible = true
	_3.get_child(3).visible = true

func _process(delta: float) -> void:
	pass
