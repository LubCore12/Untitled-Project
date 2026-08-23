extends CharacterBody3D

@onready var timer = $Timer
@onready var hp_bar = $CanvasLayer/ColorRect

@export_group("Movement")
@export var speed: float
@export var hp: float
@export var damage: float

var player: CharacterBody3D
var direction: Vector3
var current_speed: float
var is_in_area: bool

func setup(body):
	player=body
	current_speed = speed

func _process(_delta: float) -> void:
	var screen_pos = player.get_node("Camera").unproject_position(global_position)
	hp_bar.position=screen_pos

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func get_input(_delta) -> void:
	current_speed = speed
	direction = global_position.direction_to(player.global_position)

func move() -> void:
	velocity = direction * current_speed
	move_and_slide()

func get_damage(self_damage):
	hp -= self_damage
	hp_bar.value = hp
	if hp <= 0:
		collision_layer = 2
		collision_mask = 2
		set_physics_process(false)

func attack():
	player.get_damage(damage)
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		is_in_area=true
		attack()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_in_area=false

func _on_timer_timeout() -> void:
	if is_in_area:
		attack()
