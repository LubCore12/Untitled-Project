class_name EnemyLong
extends CharacterBody3D

@onready var sprite = $Sprite
@onready var arrow_scene = preload("res://scenes/arrow.tscn")

@export_group("Movement")
@export var run_speed: float = 2.5
@export var walk_speed: float = 2.5
@export var hp: float = 100.0
@export var damage: float = 20.0

var player: CharacterBody3D
var direction: float
var speed: float
var is_in_attack_area: bool
var is_in_shot_area: bool
var is_see_player: bool
var is_shooting: bool
var is_dead := false

signal spawn_arrow(arrow)

func setup(body, spawn_position):
	player = body
	position = spawn_position
	speed = walk_speed

func _physics_process(_delta: float) -> void:
	speed = walk_speed
	
	if not is_dead:
		if is_see_player:
			direction = (player.position - position).normalized().x if is_see_player else 0.0
			if is_in_attack_area:
				attack()
			elif is_in_shot_area:
				shot()
			else:
				go_to_player()
		else:
			idle_walking()
	animate()

func go_to_player() -> void:
	is_shooting = false
	velocity.x = direction * speed
	sprite.play("walk")
	move_and_slide()
	
func idle_walking() -> void:
	is_shooting = false
	sprite.play("walk")
	velocity.x = 0
	
func animate() -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true 

func attack() -> void:
	is_shooting = false
	sprite.play("attack")
	await get_tree().create_timer(1.5).timeout
	player.get_damage(damage)
	
func shot() -> void:
	velocity.x = direction * walk_speed if sprite.animation == "walk" else 0.0
	if not is_shooting:
		is_shooting = true
		sprite.play("shot")
		await get_tree().create_timer(3).timeout
		
		if sprite.animation == "shot" and sprite.frame == 14:
			var arrow = arrow_scene.instantiate()
			spawn_arrow.emit(arrow)
			arrow.setup(global_position + Vector3(0, 1.6, 0), player)
			await sprite.animation_finished
			sprite.play("walk")
			is_shooting = false
			await get_tree().create_timer(0.7).timeout
	move_and_slide()

func get_damage(self_damage):
	hp -= self_damage
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), 0.15)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.15)
	
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

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		is_see_player = true

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		is_see_player = false

func _on_shot_area_body_entered(body: Node3D) -> void:
	if body == player:
		is_in_shot_area = true

func _on_shot_area_body_exited(body: Node3D) -> void:
	if body == player:
		is_in_shot_area = false
