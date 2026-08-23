extends Control

@onready var cards = $ChoiceCards
@onready var button_child = "Panel"

@onready var sprite_button = $ChoiceCards/CharacterSpriteButton
@onready var walk_button = $ChoiceCards/WalkButton
@onready var wood_environment_button = $ChoiceCards/WoodEnvironmentButton
@onready var rock_environment_button = $ChoiceCards/RockEnvironmentButton
@onready var day_light_button = $ChoiceCards/DayLightButton
@onready var night_light_button = $ChoiceCards/NightLightButton
@onready var enemy_close_creation_button = $ChoiceCards/EnemyCloseCreationButton
@onready var enemy_long_creation_button = $ChoiceCards/EnemyLongCreationButton
@onready var circle_health_button = $ChoiceCards/CircleHealthButton
@onready var line_health_button = $ChoiceCards/LineHealthButton
@onready var bottle_health_button = $ChoiceCards/BottleHealthButton

signal give_walk_ability
signal create_character_sprite
signal make_wood_environment
signal make_rock_environment
signal set_day_light
signal set_night_light
signal make_enemy_close_creation
signal add_circle_health
signal add_line_health
signal add_bottle_health
signal make_enemy_long_creation

signal choice_done

func _ready() -> void:
	for button in cards.get_children():
		button.mouse_entered.connect(entered_event.bind(button))
		button.mouse_exited.connect(exited_event.bind(button))
		button.pressed.connect(pressed_event)

func entered_event(button: Button) -> void:
	button.pivot_offset = button.size / 2
	var tween = create_tween().parallel()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.3)
	tween.tween_property(button.get_node(button_child).material, "shader_parameter/x_pos", -1.8, 0.3).from(1.7)
	GlobalSounds.play_random_hover_sound()
	
func exited_event(button: Button) -> void:
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.4)

func pressed_event() -> void:
	GlobalSounds.play_random_pressed_sound()
	choice_done.emit()
	hide()

func toggle_sprite_choice() -> void:
	if sprite_button.visible:
		sprite_button.hide()
	else:
		sprite_button.show()

func toggle_walk_choice() -> void:
	if walk_button.visible:
		walk_button.hide()
	else:
		walk_button.show()

func toggle_environment_choice() -> void:
	if wood_environment_button.visible:
		wood_environment_button.hide()
		rock_environment_button.hide()
	else:
		wood_environment_button.show()
		rock_environment_button.show()

func toggle_light_choice() -> void:
	if day_light_button.visible:
		day_light_button.hide()
		night_light_button.hide()
	else:
		day_light_button.show()
		night_light_button.show()
		
func toggle_enemy_choice() -> void:
	if enemy_close_creation_button.visible:
		enemy_close_creation_button.hide()
		enemy_long_creation_button.hide()
	else:
		enemy_close_creation_button.show()
		enemy_long_creation_button.show()

func toggle_health_choice() -> void:
	if circle_health_button.visible:
		circle_health_button.hide()
		line_health_button.hide()
		bottle_health_button.hide()
	else:
		circle_health_button.show()
		line_health_button.show()
		bottle_health_button.show()

func _on_walk_button_pressed() -> void:
	give_walk_ability.emit()

func _on_wood_environment_button_pressed() -> void:
	make_wood_environment.emit()

func _on_rock_environment_button_pressed() -> void:
	make_rock_environment.emit()

func _on_day_light_button_pressed() -> void:
	set_day_light.emit()

func _on_night_light_button_pressed() -> void:
	set_night_light.emit()

func _on_enemy_close_creation_button_pressed() -> void:
	make_enemy_close_creation.emit()

func _on_enemy_long_creation_button_pressed() -> void:
	make_enemy_long_creation.emit()

func _on_circle_health_button_pressed() -> void:
	add_circle_health.emit()

func _on_line_health_bar_pressed() -> void:
	add_line_health.emit()

func _on_bottle_health_bar_pressed() -> void:
	add_bottle_health.emit()

func _on_character_sprite_button_pressed() -> void:
	create_character_sprite.emit()
