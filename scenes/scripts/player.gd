class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var speed: float

@onready var mesh = $Mesh

var direction: Vector2
var can_walk := false

func _physics_process(_delta: float) -> void:
	get_input()
	if can_walk:
		move()
	
func move() -> void:
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
func start_walking() -> void:
	can_walk = true
	
func create_cube_mesh() -> void:
	mesh.mesh = BoxMesh.new()
	
func create_sphere_mesh() -> void:
	scale = Vector3(1.3, 1.3, 1.3)
	mesh.mesh = SphereMesh.new()
