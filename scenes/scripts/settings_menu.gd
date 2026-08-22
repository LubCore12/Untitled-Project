extends Control

func _on_close_button_pressed() -> void:
	hide()

func _on_music_slider_value_changed(value: float) -> void:
	Global.music_loud = value

func _on_sfx_slider_value_changed(value: float) -> void:
	Global.sfx_loud = value
