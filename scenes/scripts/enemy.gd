extends CharacterBody3D

@onready var timer = $Timer
@onready var hp_bar = $ColorRect
@onready var mesh = $MeshInstance3D

@export_group("Movement")
@export var speed: float = 100.0
@export var hp: float = 100.0
@export var damage: float = 20.0

var player: CharacterBody3D
var direction: Vector3
var current_speed: float
var is_in_area: bool

func setup(body):
	player = body
	current_speed = speed

func _process(_delta: float) -> void:
	var screen_pos = player.get_node("Camera").unproject_position(global_position)
	hp_bar.position = screen_pos
	hp_bar.size = Vector2(100, 15)
	hp_bar.position.y = -100

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func get_input(delta) -> void:
	current_speed = speed * delta
	if player:
		direction = (player.position - position).normalized()

func move() -> void:
	velocity = direction * current_speed
	move_and_slide()

func get_damage(self_damage):
	hp -= self_damage
	mesh.material_override.albedo_color = Color.RED
	await get_tree().create_timer(0.5).timeout
	mesh.material_override.albedo_color = Color(1.0, 0.0, 1.0, 1.0)
	if hp <= 0:
		collision_layer = 2
		collision_mask = 2
		set_physics_process(false)

func attack():
	player.get_damage(damage)
	timer.start()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		is_in_area = true
		attack()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		is_in_area = false

func _on_timer_timeout() -> void:
	if is_in_area:
		print('a')
		attack()
