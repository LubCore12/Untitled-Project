class_name EnemyClose
extends CharacterBody3D

@onready var timer = $Timer
@onready var sprite = $Sprite

@export_group("Movement")
@export var run_speed: float = 2.5
@export var walk_speed: float = 2.5
@export var hp: float = 100.0
@export var damage: float = 20.0

var origin_position: float
var idle_walking_offset := randf_range(8.0, 12.0)
var player: CharacterBody3D
var direction: float
var speed: float
var is_in_attack_area: bool
var is_see_player: bool
var is_dead := false
var tween

func setup(body, spawn_position):
	player = body
	position = spawn_position
	origin_position = spawn_position.x
	speed = walk_speed
	tween = create_tween()
	tween.set_loops()
	tween.tween_callback(func(): direction = 1.0)
	tween.tween_property(self, "position:x", origin_position + idle_walking_offset, 5.0)
	tween.tween_callback(func(): direction = 0.0)
	tween.tween_interval(1.5)
	tween.tween_callback(func(): direction = -1.0)
	tween.tween_property(self, "position:x", origin_position, 5.0)
	tween.tween_callback(func(): direction = 0.0)
	tween.tween_interval(2.7)

func _physics_process(_delta: float) -> void:
	speed = walk_speed
	
	if not is_dead:
		if is_see_player:
			if player:
				direction = (player.position - position).normalized().x if is_see_player else 0.0
			go_to_player()
		else:
			idle_walking()
	animate()

func go_to_player() -> void:
	tween.pause()
	velocity.x = direction * speed
	move_and_slide()
	
func idle_walking() -> void:
	tween.play()
	
func animate() -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true 
	
	if not is_in_attack_area and not is_dead:
		if is_see_player:
			sprite.play("run")
		else:
			if direction:
				sprite.play("walk")
			else:
				sprite.play("idle")

func attack() -> void:
	sprite.play("attack")
	await get_tree().create_timer(0.8).timeout
	player.get_damage(damage)

func get_damage(self_damage):
	hp -= self_damage
	if hp <= 0:
		sprite.play("dead")
		is_dead = true
		collision_layer = 2
		collision_mask = 2
		set_physics_process(false)
		destroy()
		return true
	return false
	
func destroy() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _on_timer_timeout() -> void:
	if is_in_attack_area and not is_dead:
		attack()

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body == player:
		is_in_attack_area = true

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body == player:
		is_in_attack_area = false

func _on_view_area_body_entered(body: Node3D) -> void:
	if body == player:
		is_see_player = true

func _on_view_area_body_exited(body: Node3D) -> void:
	if body == player:
		is_see_player = false
