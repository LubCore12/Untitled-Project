class_name EnemyLong
extends CharacterBody3D

@onready var timer = $Timer
@onready var bullet_scene = preload("res://scenes/bullet.tscn")

@export_group("Movement")
@export var speed: float = 100.0
@export var hp: float = 100.0
@export var damage: float = 20.0

var player: CharacterBody3D
var direction: float
var current_speed: float
var is_in_area: bool
var idx: int

func setup(body):
	player = body
	current_speed = speed

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func get_input(delta) -> void:
	current_speed = speed * delta
	if player and not is_in_area:
		direction = (player.position - position).normalized().x
	else:
		current_speed = 0

func move() -> void:
	velocity.x = direction * current_speed
	move_and_slide()

func attack() -> void:
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = global_position
	bullet.global_position.y += 0.5
	bullet.direction = direction
	bullet.setup(player)

func get_damage(self_damage):
	hp -= self_damage
	if hp <= 0:
		SaveManager.game_stats["enemies"][idx] = -1
		collision_layer = 2
		collision_mask = 2
		set_physics_process(false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		is_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		is_in_area = false

func _on_timer_timeout() -> void:
	if is_in_area:
		attack()
