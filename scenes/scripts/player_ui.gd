extends Control

@onready var line_bar = $VBoxContainer/HealthBarTypes/LineBar
@onready var circle_bar = $VBoxContainer/HealthBarTypes/CircleBar
@onready var bottle_bar = $VBoxContainer/HealthBarTypes/BottleBar
@onready var vignette = $Vignette

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
	var tween = create_tween().parallel()
	if current_bar:
		tween.tween_property(current_bar.material, "shader_parameter/value", value, 0.3)
	tween.tween_property(vignette.material, "shader_parameter/strength", 1.0 - value, 0.4)
	
