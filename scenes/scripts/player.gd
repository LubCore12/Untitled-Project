class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var speed: float

@export_group("Stats")
@export var damage: float = 30
@export var max_hp: float = 100

@onready var mesh = $Mesh

var direction: Vector2
var target_enemy: CharacterBody3D
var can_walk := false
var can_attack := false
var hp: float

signal player_damaged

func _ready() -> void:
	hp = max_hp

func _physics_process(_delta: float) -> void:
	get_input()
	if can_walk:
		move()
	
func move() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
func start_walking() -> void:
	can_walk = true
	
func start_attack() -> void:
	can_attack = true
	
func attack():
	target_enemy.get_damage(damage)

func create_cube_mesh() -> void:
	mesh.mesh = BoxMesh.new()
	
func create_sphere_mesh() -> void:
	scale = Vector3(1.3, 1.3, 1.3)
	mesh.mesh = SphereMesh.new()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		target_enemy = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == target_enemy:
		target_enemy = null

func get_damage(self_damage):
	if can_attack:
		player_damaged.emit()
		hp -= self_damage
		
		if hp <= 0:
			collision_layer = 2
			collision_mask = 2
			set_physics_process(false)
