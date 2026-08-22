extends Control

@export_group("DialogStats")
@export var letter_time := 0.1
@export var space_time := 0.25

@onready var dialog_text = $DialogText
@onready var transition = $Transition
@onready var total_characters = $DialogText.get_total_character_count()
@onready var skip_button = $SkipButton

var game_scene := "res://scenes/game.tscn"
var transition_time := 1.0
var skip_button_pressed := false

func _ready() -> void:
	await display_text(dialog_text)
	await display_text(dialog_text)
	
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
		else:
			await get_tree().create_timer(letter_time).timeout
		
		if skip_button_pressed:
			skip_button_pressed = false
			break

func _on_skip_button_button_down() -> void:
	skip_button_pressed = true
