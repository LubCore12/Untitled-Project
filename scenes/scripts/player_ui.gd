extends Control

@onready var line_bar = $VBoxContainer/HealthBarTypes/LineBar
@onready var circle_bar = $VBoxContainer/HealthBarTypes/CircleBar
@onready var bottle_bar = $VBoxContainer/HealthBarTypes/BottleBar

func show_line() -> void:
	line_bar.show()
	
func show_circle() -> void:
	circle_bar.show()
	
func show_bottle() -> void:
	bottle_bar.show()
