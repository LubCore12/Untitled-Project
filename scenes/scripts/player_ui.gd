extends Control

@onready var line_bar = $VBoxContainer/Box/HealthBarTypes/LineBar
@onready var circle_bar = $VBoxContainer/Box/HealthBarTypes/CircleBar
@onready var bottle_bar = $VBoxContainer/Box/HealthBarTypes/BottleBar
@onready var vignette = $Vignette
@onready var pause_button = $VBoxContainer/Box/PauseButton
@onready var pause = $Pause

var current_bar

func show_line() -> void:
	SaveManager.game_stats["hp bar type"] = 0
	current_bar = line_bar
	line_bar.show()
	
func show_circle() -> void:
	SaveManager.game_stats["hp bar type"] = 1
	current_bar = circle_bar
	circle_bar.show()
	
func show_bottle() -> void:
	SaveManager.game_stats["hp bar type"] = 2
	current_bar = bottle_bar
	bottle_bar.show()
	
func show_pause_button() -> void:
	SaveManager.game_stats["can pause"] = true
	pause_button.show()

func set_health(value: float):
	SaveManager.game_stats["health"] = value
	var tween = create_tween().parallel()
	if current_bar:
		tween.tween_property(current_bar.material, "shader_parameter/value", value, 0.3)
	tween.tween_property(vignette.material, "shader_parameter/strength", 1.0 - value, 0.4)

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause.show()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause.hide()

func _on_exit_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_give_up_pressed() -> void:
	get_tree().quit()
