class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 3
@export var run_speed: float = 3
@export var jump_strength: float = 70
@export var gravity: float = 30

@export_group("Stats")
@export var damage: float = 30
@export var max_hp: float = 100

@onready var sprite = $Sprite

var direction: float
var target_enemy: CharacterBody3D
var can_walk := false
var can_attack := false
var hp: float
var speed: float

signal player_damaged(damage: float)

func _ready() -> void:
	hp = max_hp
	speed = walk_speed

func _physics_process(_delta: float) -> void:
	get_input()
	if can_walk:
		move()
	
func move() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
	velocity.x = direction * speed
	velocity.y -= gravity
	move_and_slide()
	
func get_input() -> void:
	speed = walk_speed
	direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		velocity.y += jump_strength
		
	if Input.is_action_pressed("run"):
		speed = run_speed
	
func start_walking() -> void:
	can_walk = true
	
func start_attack() -> void:
	can_attack = true
	
func attack():
	target_enemy.get_damage(damage)

func show_sprite() -> void:
	sprite.show()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		target_enemy = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == target_enemy:
		target_enemy = null

func get_damage(self_damage):
	hp -= self_damage
	player_damaged.emit(hp * (1.0 / max_hp))
	
	if hp <= 0:
		collision_layer = 2
		collision_mask = 2
		set_physics_process(false)
