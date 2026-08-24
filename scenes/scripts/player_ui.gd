extends Control

@onready var line_bar = $LeftTopContainer/HealthBarTypes/LineBar
@onready var circle_bar = $LeftTopContainer/HealthBarTypes/CircleBar
@onready var bottle_bar = $LeftTopContainer/HealthBarTypes/BottleBar
@onready var dash_bar = $DashContainer/DashBar
@onready var dash_label = $DashContainer/State
@onready var vignette = $Vignette
@onready var stamina_bar = $StaminaBar
@onready var blindness = $Blindness
@onready var flashbang = $Flashbang

var current_bar

func show_line() -> void:
	current_bar = line_bar
	line_bar.show()
	
func show_circle() -> void:
	current_bar = circle_bar
	circle_bar.show()
	
func show_bottle() -> void:
	current_bar = bottle_bar
	bottle_bar.show()

func set_health(value: float) -> void:
	var tween = create_tween().parallel()
	if current_bar:
		tween.tween_property(current_bar.material, "shader_parameter/value", value, 0.3)
	tween.tween_property(vignette.material, "shader_parameter/strength", 1.0 - value, 0.4)
	
func show_stamina() -> void:
	stamina_bar.show()
	
func show_blindness() -> void:
	blindness.show()
	
func set_stamina(value: float) -> void:
	var tween = create_tween()
	tween.tween_property(stamina_bar.material, "shader_parameter/value", value, 0.3)

func set_dash_time(value: float) -> void:
	var tween = create_tween()
	tween.tween_property(dash_bar.material, "shader_parameter/value", value, 0.3)
	
	if value == 1.0:
		dash_label.text = "Ready!"
	else:
		dash_label.text = "Loading.."
