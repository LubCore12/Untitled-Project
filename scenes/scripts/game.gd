class_name Game
extends Node3D

@onready var transition = $CanvasLayer/ColorRect
@onready var choice_menu = $CanvasLayer/ChoiceMenu
@onready var dialog_panel = $CanvasLayer/DialogPanel
@onready var dialogs = $CanvasLayer/Dialogs
@onready var player = $Player as Player
@onready var enemies = $Enemies
@onready var player_ui = $CanvasLayer/PlayerUI
@onready var wood_environment = $WoodEnvironment
@onready var rock_environment = $RockEnvironment
@onready var day_light = $DirectionalLights/Day
@onready var night_light = $DirectionalLights/Night
@onready var enemy_close_scene = preload("res://scenes/enemy_close.tscn")
@onready var enemy_long_scene = preload("res://scenes/enemy_long.tscn")

@export_group("DialogStats")
@export var letter_time := 0.05
@export var punctuation_time := 0.3
@export var comma_time := 0.185
@export var space_time := 0.125
@export var dialog_wait_time := 0.7

var transition_time := 1.0

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/size", 0.0, transition_time).from(1.0)
	
	await get_tree().create_timer(2.0).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(0).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_sprite_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_sprite_choice()
	await get_tree().create_timer(0.5).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(1).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_walk_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_walk_choice()
	await get_tree().create_timer(3).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(2).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_environment_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_environment_choice()
	await get_tree().create_timer(3).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(3).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_light_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_light_choice()
	await get_tree().create_timer(2).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(4).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_enemy_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_enemy_choice()
	await get_tree().create_timer(2).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(5).get_children():
		await display_text(label)
		
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	choice_menu.toggle_health_choice()
	choice_menu.show()
	await choice_menu.choice_done
	choice_menu.toggle_health_choice()
	await get_tree().create_timer(2).timeout
	dialog_panel.show()
	
	for label in dialogs.get_child(5).get_children():
		await display_text(label)
	
	dialog_panel.hide()
	await get_tree().create_timer(0.5).timeout
	
	for i in range(8):
		choice_menu.show()
		choice_menu.choice_random_buttons()
		await choice_menu.choice_done
		choice_menu.hide()
		choice_menu.hide_all_choices()
		await get_tree().create_timer(0.5).timeout
	
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

	await get_tree().create_timer(dialog_wait_time).timeout
	text.visible_characters = 0

func _on_player_player_damaged(damage: float) -> void:
	player_ui.set_health(damage)

func _on_player_player_run(stamina: float) -> void:
	player_ui.set_stamina(stamina)

func _on_player_player_dash_time(time: float) -> void:
	player_ui.set_dash_time(time)

func _on_choice_menu_give_walk_ability() -> void:
	player.start_walking()
	player_ui.show_stamina()

func _on_choice_menu_make_rock_environment() -> void:
	rock_environment.show()

func _on_choice_menu_make_wood_environment() -> void:
	wood_environment.show()

func _on_choice_menu_set_day_light() -> void:
	day_light.show()

func _on_choice_menu_set_night_light() -> void:
	night_light.show()

func _on_choice_menu_make_enemy_close_creation() -> void:
	var enemy = enemy_close_scene.instantiate()
	enemy.setup(player)
	enemy.position.x = -10
	enemies.add_child(enemy)

func _on_choice_menu_make_enemy_long_creation() -> void:
	var enemy = enemy_long_scene.instantiate()
	enemy.setup(player)
	enemy.position.x = -10
	enemies.add_child(enemy)

func _on_choice_menu_add_bottle_health() -> void:
	player.start_attack()
	player_ui.show_bottle()

func _on_choice_menu_add_circle_health() -> void:
	player.start_attack()
	player_ui.show_circle()

func _on_choice_menu_add_line_health() -> void:
	player.start_attack()
	player_ui.show_line()
	
func _on_choice_menu_create_character_sprite() -> void:
	player.show_sprite()

func _on_choice_menu_six_seeeevenaaaaaa() -> void:
	player.add_damage_multiplier(0.05)

func _on_choice_menu_best_friend() -> void:
	pass

func _on_choice_menu_black() -> void:
	player.add_defend_multiplier(-0.1)

func _on_choice_menu_blind() -> void:
	player_ui.show_blindness()

func _on_choice_menu_broken_bone() -> void:
	player.add_max_health_multiplier(-0.1)
	player.add_speed_multiplier(-0.1)

func _on_choice_menu_dementia() -> void:
	choice_menu.hide_descriptions()

func _on_choice_menu_disabled() -> void:
	player.add_speed_multiplier(-0.4)

func _on_choice_menu_dyspnea() -> void:
	player.add_max_stamina_multiplier(-0.5)

func _on_choice_menu_fat_guy() -> void:
	player.add_max_health_multiplier(0.4)
	player.add_damage_multiplier(-0.15)

func _on_choice_menu_flash() -> void:
	player.start_dashing()

func _on_choice_menu_flashbang() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(player_ui.flashbang, "modulate:a", 1.0, 0.1)
	tween.parallel().tween_property(day_light, "light_energy", 20.0, 0.2)
	tween.tween_interval(0.4)
	night_light.hide()
	day_light.show()
	tween.tween_property(player_ui.flashbang, "modulate:a", 0.0, 1.1)

func _on_choice_menu_gamer() -> void:
	player.add_defend_multiplier(-0.15)

func _on_choice_menu_iron_dude() -> void:
	player.add_defend_multiplier(0.1)
	player.add_speed_multiplier(-0.05)

func _on_choice_menu_perfect() -> void:
	player.add_damage_multiplier(0.1)
	player.add_defend_multiplier(0.1)
	player.add_max_health_multiplier(0.1)

func _on_choice_menu_rage() -> void:
	player.enable_rage()
	player.add_defend_multiplier(-0.1)

func _on_choice_menu_redeemer() -> void:
	pass

func _on_choice_menu_serious_punch() -> void:
	player.add_damage_multiplier(0.8)
	player.add_speed_multiplier(-0.15)
	player.add_max_stamina_multiplier(-0.2)
	player.is_punch_discard_stamina = true

func _on_choice_menu_sonic() -> void:
	player.add_speed_multiplier(0.35)

func _on_choice_menu_spawnrate() -> void:
	pass

func _on_choice_menu_special_agent() -> void:
	player.add_max_stamina_multiplier(0.3)

func _on_choice_menu_student() -> void:
	player.add_damage_multiplier(-0.10)
	player.add_max_health_multiplier(-0.15)

func _on_choice_menu_thin() -> void:
	player.add_max_health_multiplier(-0.2)

func _on_choice_menu_vampire() -> void:
	player.add_health(player.get_right_max_health() * 0.15)

func _on_choice_menu_zombie_with_bucket() -> void:
	player.add_defend_multiplier(0.2)
	player.add_max_health_multiplier(-0.15)

func _on_choice_menu_gambling() -> void:
	choice_menu.add_luck(1.0)

func _on_choice_menu_unlucky() -> void:
	choice_menu.add_luck(-1.0)

func _on_choice_menu_card_limit() -> void:
	pass
