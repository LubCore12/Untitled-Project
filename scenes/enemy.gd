extends CharacterBody3D

@export_group("Movement")
@export var speed = 1.5

var player: CharacterBody3D
var direction: Vector3

func setup(body: CharacterBody3D):
	player = body
	
func _physics_process(_delta: float) -> void:
	if player:
		direction = (player.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		move_and_slide()
	
