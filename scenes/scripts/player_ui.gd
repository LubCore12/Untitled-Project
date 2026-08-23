extends Control

@onready var line_bar = $VBoxContainer/HealthBarTypes/LineBar
@onready var circle_bar = $VBoxContainer/HealthBarTypes/CircleBar
@onready var bottle_bar = $VBoxContainer/HealthBarTypes/BottleBar

var current_bar

func show_line() -> void:
	current_bar = line_bar
	line_bar.show()
	
func show_circle() -> void:
	current_bar = circle_bar
	circle_bar.show()
	
func show_bottle() -> void:
	current_bar = bottle_bar
	bottle_bar.show()

func discard_health(value: float):
	var tween = create_tween()
	var current_hp = current_bar.material.get_shader_parameter("value")
	tween.tween_property(current_bar.material, "shader_parameter/value", current_hp - value * 0.01, 0.3)
	
