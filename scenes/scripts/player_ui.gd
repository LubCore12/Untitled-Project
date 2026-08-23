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

func set_health(value: float):
	if current_bar:
		var tween = create_tween()
		tween.tween_property(current_bar.material, "shader_parameter/value", value, 0.3)
	
