extends Node2D

@onready var transition = $CanvasLayer/Transition

var transition_time := 1.0

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/size", 0.0, transition_time).from(1.0)
