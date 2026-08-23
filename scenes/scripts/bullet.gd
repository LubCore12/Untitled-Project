extends Area3D

@export_group("stats")
@export var speed: float
@export var damage: float

var direction: float
var player: CharacterBody3D

func setup(body) -> void:
	player = body

func _process(delta: float) -> void:
	global_position.x += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player.get_damage(damage)
	elif not body is EnemyLong:
		queue_free()
