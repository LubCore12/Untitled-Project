extends Control

@onready var cards = $ChoiceCards
@onready var button_child = "Panel"

@onready var sprite_button = $ChoiceCards/StoryChoices/CharacterSpriteButton
@onready var walk_button = $ChoiceCards/StoryChoices/WalkButton
@onready var wood_environment_button = $ChoiceCards/StoryChoices/WoodEnvironmentButton
@onready var rock_environment_button = $ChoiceCards/StoryChoices/RockEnvironmentButton
@onready var day_light_button = $ChoiceCards/StoryChoices/DayLightButton
@onready var night_light_button = $ChoiceCards/StoryChoices/NightLightButton
@onready var enemy_close_creation_button = $ChoiceCards/StoryChoices/EnemyCloseCreationButton
@onready var enemy_long_creation_button = $ChoiceCards/StoryChoices/EnemyLongCreationButton
@onready var circle_health_button = $ChoiceCards/StoryChoices/CircleHealthButton
@onready var line_health_button = $ChoiceCards/StoryChoices/LineHealthButton
@onready var bottle_health_button = $ChoiceCards/StoryChoices/BottleHealthButton
@onready var pause_button = $ChoiceCards/StoryChoices/PauseButton

@onready var story_choices = $ChoiceCards/StoryChoices
@onready var bad_choices = $ChoiceCards/BadChoices
@onready var good_choices = $ChoiceCards/GoodChoices

var bad_button_chance := 4.0
var cards_per_choice := 3

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
signal pause

signal flash
signal special_agent
signal serious_punch
signal iron_dude
signal vampire
signal rage
signal zombie_with_bucket
signal perfect
signal fat_guy
signal SIX_SEEEEVENAAAAAA
signal sonic
signal card_limit
signal gambling

signal broken_bone
signal thin
signal disabled
signal blind
signal flashbang
signal dementia
signal dyspnea
signal black
signal student
signal gamer
signal unlucky

signal choice_done

func _ready() -> void:
	for card_selection in cards.get_children():
		for button in card_selection.get_children():
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

func toggle_pause_choice() -> void:
	if pause_button.visible:
		pause_button.hide()
	else:
		pause_button.show()

func choice_random_buttons() -> void:
	story_choices.hide()
	var chance = randf_range(0.0, 10.0)
	
	if chance <= bad_button_chance:
		good_choices.hide()
		bad_choices.show()
		var children = bad_choices.get_children()
		children.shuffle()
		show_cards(children)
	else:
		good_choices.show()
		bad_choices.hide()
		var children = good_choices.get_children()
		children.shuffle()
		show_cards(children)
	
func show_cards(children) -> void:
	for i in range(cards_per_choice):
		var card = children[i]
		card.process_mode = PROCESS_MODE_DISABLED
		card.show()
			
	await get_tree().create_timer(1.0).timeout
		
	for i in range(cards_per_choice):
		var card = children[i]
		cards_per_choice = 3
		card.process_mode = PROCESS_MODE_INHERIT
			
func hide_all_choices() -> void:
	for good in good_choices.get_children():
		good.hide()
	for bad in bad_choices.get_children():
		bad.hide()

func hide_descriptions() -> void:
	for button in good_choices.get_children():
		button.get_node("Panel").get_node("VBoxContainer").get_node("Description").modulate.a = 0
	for button in bad_choices.get_children():
		button.get_node("Panel").get_node("VBoxContainer").get_node("Description").modulate.a = 0

func add_luck(value: float) -> void:
	bad_button_chance -= value

func set_four_cards() -> void:
	cards_per_choice = 4

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

func _on_flash_button_pressed() -> void:
	flash.emit()

func _on_special_agent_button_pressed() -> void:
	special_agent.emit()
	
func _on_serious_punch_button_pressed() -> void:
	serious_punch.emit()

func _on_iron_dude_button_pressed() -> void:
	iron_dude.emit()

func _on_vampire_button_pressed() -> void:
	vampire.emit()
	
func _on_rage_button_pressed() -> void:
	rage.emit()

func _on_zombie_with_bucket_button_pressed() -> void:
	zombie_with_bucket.emit()

func _on_perfect_button_pressed() -> void:
	perfect.emit()


func _on_fat_guy_button_pressed() -> void:
	fat_guy.emit()

func _on_button_pressed() -> void:
	SIX_SEEEEVENAAAAAA.emit()

func _on_sonic_button_pressed() -> void:
	sonic.emit()

func _on_broken_bone_button_pressed() -> void:
	broken_bone.emit()

func _on_thin_button_pressed() -> void:
	thin.emit()

func _on_disabled_button_pressed() -> void:
	disabled.emit()

func _on_blind_button_pressed() -> void:
	blind.emit()
	
func _on_flashbang_button_pressed() -> void:
	flashbang.emit()

func _on_dementia_button_pressed() -> void:
	dementia.emit()

func _on_dyspnea_button_pressed() -> void:
	dyspnea.emit()

func _on_black_button_pressed() -> void:
	black.emit()

func _on_student_button_pressed() -> void:
	student.emit()

func _on_gamer_button_pressed() -> void:
	gamer.emit()

func _on_card_limit_button_pressed() -> void:
	card_limit.emit()

func _on_gambling_button_pressed() -> void:
	gambling.emit()

func _on_unlucky_button_pressed() -> void:
	unlucky.emit()

func _on_pause_button_pressed() -> void:
	pause.emit()
