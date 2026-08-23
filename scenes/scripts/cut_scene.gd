extends Control

@export_group("DialogStats")
@export var letter_time := 0.05
@export var space_time := 0.075
@export var comma_time := 0.185
@export var punctuation_time := 0.3
@export var dialog_wait_time := 0.7

@onready var dialogs = $Dialogs
@onready var transition = $Transition
@onready var skip_button = $SkipButton

var game_scene := "res://scenes/game.tscn"
var transition_time := 1.0
var skip_button_pressed := false

func _ready() -> void:
	for dialog in dialogs.get_children():
		await display_text(dialog)
	
	var tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/size", 1.0, transition_time).from(0.0)
	await get_tree().create_timer(transition_time + 0.5).timeout
	
	get_tree().change_scene_to_file(game_scene)
	
func display_text(text: RichTextLabel):
	text.visible_characters = 0
	var total_chars = text.get_total_character_count()
	
	for i in range(total_chars):
		text.visible_characters += 1
		var current_char = text.get_parsed_text()[i]
		
		if current_char == " ":
			await get_tree().create_timer(space_time).timeout
		elif current_char == ",":
			await get_tree().create_timer(comma_time).timeout
		elif current_char in [".", "!", "?", "-"]:
			await get_tree().create_timer(punctuation_time).timeout
		else:
			await get_tree().create_timer(letter_time).timeout
		
		if skip_button_pressed and text.visible_characters >= 5:
			break

	if not skip_button_pressed:
		await get_tree().create_timer(dialog_wait_time).timeout
	else:
		skip_button_pressed = false
		
	text.visible_characters = 0

func _on_skip_button_button_down() -> void:
	skip_button_pressed = true
