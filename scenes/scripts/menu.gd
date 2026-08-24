extends Control

@onready var game_scene = "res://scenes/game.tscn"
@onready var cut_scene = "res://scenes/cut_scene.tscn"
@onready var settings_menu = $SettingsMenu
@onready var buttons = $ActionButtons
@onready var play_button = $ActionButtons/Play
@onready var continue_button = $ActionButtons/Continue
@onready var give_up_button = $ActionButtons/GiveUp
@onready var pressed_sound = $Sounds/PressedSound
@onready var hover_sound = $Sounds/HoverSound

func _ready() -> void:
	for button in buttons.get_children():
		button.material.set_shader_parameter("strength", randf_range(2.0, 5.0))
		button.material.set_shader_parameter("x_speed", randf_range(1.0, 3.0))
		button.material.set_shader_parameter("y_speed", randf_range(1.0, 3.0))

func _on_play_pressed() -> void:
	GlobalSounds.play_random_pressed_sound()
	get_tree().change_scene_to_file(cut_scene)

func _on_settings_button_pressed() -> void:
	GlobalSounds.play_random_pressed_sound()
	settings_menu.show()

func _on_give_up_pressed() -> void:
	GlobalSounds.play_random_pressed_sound()
	get_tree().quit()
	
func scale_up_button(button: Button) -> void:
	var tween = create_tween()
	GlobalSounds.play_random_hover_sound()
	button.pivot_offset = button.size / 2
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)

func scale_down_button(button: Button) -> void:
	var tween = create_tween()
	button.pivot_offset = button.size / 2
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)

func _on_play_mouse_entered() -> void:
	scale_up_button(play_button)

func _on_play_mouse_exited() -> void:
	scale_down_button(play_button)

func _on_continue_mouse_entered() -> void:
	scale_up_button(continue_button)

func _on_continue_mouse_exited() -> void:
	scale_down_button(continue_button)

func _on_give_up_mouse_entered() -> void:
	scale_up_button(give_up_button)

func _on_give_up_mouse_exited() -> void:
	scale_down_button(give_up_button)
