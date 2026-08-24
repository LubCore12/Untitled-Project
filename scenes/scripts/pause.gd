extends Control

var menu_scene = "res://scenes/menu.tscn"

func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene)
