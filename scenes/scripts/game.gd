class_name Game
extends Node3D

@onready var transition = $CanvasLayer/ColorRect
@onready var choice_menu = $CanvasLayer/ChoiceMenu
@onready var dialog_panel = $CanvasLayer/DialogPanel
@onready var dialogs = $CanvasLayer/Dialogs
@onready var player = $Player
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
var can_save := false
var enemies_count := 0

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/size", 0.0, transition_time).from(1.0)
	if not SaveManager.is_new_game:
		var stats = SaveManager.load_game()
		if "enemies" in stats:
			for i in stats["enemies"]:
				if i:
					_on_choice_menu_make_enemy_long_creation()
				elif i == 1:
					_on_choice_menu_make_enemy_close_creation()
		if "hp bar type" in stats:
			[_on_choice_menu_add_line_health,
			_on_choice_menu_add_circle_health,
			_on_choice_menu_add_bottle_health][stats["hp bar type"]].call()
		if "health" in stats:
			player.hp = stats["health"]
			player_ui.set_health(player.hp)
		if "can pause" in stats:
			if stats["can pause"]:
				player_ui.show_pause_button()
		if "environment" in stats:
			if stats["environment"]:
				_on_choice_menu_make_wood_environment()
			else:
				_on_choice_menu_make_rock_environment()
		if "light type" in stats:
			if stats["light type"]:
				_on_choice_menu_set_night_light()
			else:
				_on_choice_menu_set_day_light()
		player.start_walking()
		player.show_sprite()
	else:
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
		
		dialog_panel.hide()
		await get_tree().create_timer(0.5).timeout
		choice_menu.toggle_pause_or_save_choice()
		choice_menu.show()
		await choice_menu.choice_done
		choice_menu.toggle_pause_or_save_choice()
		await get_tree().create_timer(2).timeout
		dialog_panel.show()
		if can_save:
			SaveManager.save_game()

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

func _on_choice_menu_give_walk_ability() -> void:
	player.start_walking()

func _on_choice_menu_make_rock_environment() -> void:
	SaveManager.game_stats["environment"] = 0
	rock_environment.show()

func _on_choice_menu_make_wood_environment() -> void:
	SaveManager.game_stats["environment"] = 1
	wood_environment.show()

func _on_choice_menu_set_day_light() -> void:
	SaveManager.game_stats["light type"] = 0
	day_light.show()

func _on_choice_menu_set_night_light() -> void:
	SaveManager.game_stats["light type"] = 1
	night_light.show()

func _on_choice_menu_make_enemy_close_creation() -> void:
	if "enemies" in SaveManager.game_stats:
		SaveManager.game_stats["enemies"].append(0)
	else:
		SaveManager.game_stats["enemies"] = [0]
	enemies_count += 1
	var enemy = enemy_close_scene.instantiate()
	enemy.setup(player)
	enemy.position.x = -10
	enemy.idx = enemies_count
	enemies.add_child(enemy)

func _on_choice_menu_make_enemy_long_creation() -> void:
	if "enemies" in SaveManager.game_stats:
		SaveManager.game_stats["enemies"].append([1])
	else:
		SaveManager.game_stats["enemies"] = [1]
	enemies_count += 1
	var enemy = enemy_long_scene.instantiate()
	enemy.setup(player)
	enemy.position.x = -10
	enemy.idx = enemies_count
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

func _on_player_player_damaged(damage: float) -> void:
	player_ui.set_health(damage)

func _on_choice_menu_add_pause() -> void:
	player_ui.show_pause_button()

func _on_choice_menu_add_save() -> void:
	can_save = true
