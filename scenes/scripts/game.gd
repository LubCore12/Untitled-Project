extends Node2D

@onready var player = $Entities/Player
@onready var enimys = $Entities/Enimys

func _ready() -> void:
	for enimy in enimys.get_children():
		enimy.setup(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
