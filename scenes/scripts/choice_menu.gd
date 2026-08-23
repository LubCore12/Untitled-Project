extends Control

@onready var cards = $ChoiceCards
@onready var button_child = "Panel"

@onready var cube_mesh_button = $ChoiceCards/CharacterCubeMeshButton
@onready var cube_sphere_button = $ChoiceCards/CharacterSphereMeshButton
@onready var walk_button = $ChoiceCards/WalkButton
@onready var neon_environment_button = $ChoiceCards/NeonEnvironmentButton
@onready var minimal_environment_button = $ChoiceCards/MinimalEnvironmentButton
@onready var day_light_button = $ChoiceCards/DayLightButton
@onready var night_light_button = $ChoiceCards/NightLightButton
@onready var enemy_creation_button = $ChoiceCards/EnemyCreationButton
@onready var circle_health_button = $ChoiceCards/CircleHealthButton
@onready var line_health_button = $ChoiceCards/LineHealthButton
@onready var bottle_health_button = $ChoiceCards/BottleHealthButton

signal give_walk_ability
signal create_character_cube_mesh
signal create_character_sphere_mesh
signal make_neon_environment
signal make_minimal_environment
signal set_day_light
signal set_night_light
signal make_enemy_creation
signal add_circle_health
signal add_line_health
signal add_bottle_health

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

func toggle_mesh_choice() -> void:
	if cube_mesh_button.visible:
		cube_mesh_button.hide()
		cube_sphere_button.hide()
	else:
		cube_mesh_button.show()
		cube_sphere_button.show()

func toggle_walk_choice() -> void:
	if walk_button.visible:
		walk_button.hide()
	else:
		walk_button.show()

func toggle_environment_choice() -> void:
	if neon_environment_button.visible:
		neon_environment_button.hide()
		minimal_environment_button.hide()
	else:
		neon_environment_button.show()
		minimal_environment_button.show()

func toggle_light_choice() -> void:
	if day_light_button.visible:
		day_light_button.hide()
		night_light_button.hide()
	else:
		day_light_button.show()
		night_light_button.show()
		
func toggle_enemy_choice() -> void:
	if enemy_creation_button.visible:
		enemy_creation_button.hide()
	else:
		enemy_creation_button.show()

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

func _on_character_cube_mesh_button_pressed() -> void:
	create_character_cube_mesh.emit()

func _on_character_sphere_mesh_button_pressed() -> void:
	create_character_sphere_mesh.emit()

func _on_neon_environment_button_pressed() -> void:
	make_neon_environment.emit()

func _on_minimal_environment_button_pressed() -> void:
	make_minimal_environment.emit()

func _on_day_light_button_pressed() -> void:
	set_day_light.emit()

func _on_night_light_button_pressed() -> void:
	set_night_light.emit()

func _on_enemy_creation_button_pressed() -> void:
	make_enemy_creation.emit()

func _on_circle_health_button_pressed() -> void:
	add_circle_health.emit()

func _on_line_health_bar_pressed() -> void:
	add_line_health.emit()

func _on_bottle_health_bar_pressed() -> void:
	add_bottle_health.emit()
