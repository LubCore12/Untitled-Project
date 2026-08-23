class_name Enemy
extends CharacterBody3D

@onready var timer = $Timer

@export_group("Movement")
@export var speed: float = 2.5
@export var hp: float = 100.0
@export var damage: float = 20.0

var player: CharacterBody3D
var direction: float
var current_speed: float
var is_in_area: bool

func setup(body):
	player = body
	current_speed = speed

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func get_input(delta) -> void:
	current_speed = speed * delta
	if player:
		direction = (player.position - position).normalized().x

func move() -> void:
	velocity.x = direction * current_speed
	move_and_slide()

func attack() -> void:
	player.get_damage(damage)

func get_damage(self_damage):
	hp -= self_damage
	if hp <= 0:
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
