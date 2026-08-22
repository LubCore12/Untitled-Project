extends Node2D

@onready var transition = $CanvasLayer/Transition
@onready var player = $Entities/Player
@onready var enimys = $Entities/Enimys

var transition_time := 1.0

func _ready() -> void:

	var tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/size", 0.0, transition_time).from(1.0)


	for enimy in enimys.get_children():
		enimy.setup(player)

func _process(_delta: float) -> void:
	pass
