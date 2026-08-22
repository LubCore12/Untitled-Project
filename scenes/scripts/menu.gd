extends Control

@onready var game_scene = "res://scenes/game.tscn"
@onready var settings_menu = $SettingsMenu

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)

func _on_settings_button_pressed() -> void:
	settings_menu.show()
