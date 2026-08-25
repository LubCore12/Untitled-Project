extends Node

const min_music_db_sound = -40.0;
const min_sfx_db_sound = -25.0;
var music_loud = 1.0;
var sfx_loud = 1.0;

var pressed_sounds :Array = [
	preload("res://sounds/button_pressed/ButtonPressedC5.mp3"),
	preload("res://sounds/button_pressed/ButtonPressedC#5.mp3"),
	preload("res://sounds/button_pressed/ButtonPressedD5.mp3")
]

var hover_sounds :Array = [
	preload("res://sounds/button_hovered/ButtonHoveredC5.mp3"),
	preload("res://sounds/button_hovered/ButtonHoveredC#5.mp3"),
	preload("res://sounds/button_hovered/ButtonHoveredD5.mp3")
]

func play_random_pressed_sound() -> void:
	$PressedSound.stream = pressed_sounds.pick_random()
	$PressedSound.volume_db = min_sfx_db_sound + sfx_loud * 30
	$PressedSound.play()
	
func play_random_hover_sound() -> void:
	$HoverSound.stream = hover_sounds.pick_random()
	$HoverSound.volume_db = min_sfx_db_sound + sfx_loud * 30
	$HoverSound.play()
