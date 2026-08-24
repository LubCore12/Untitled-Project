class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 4
@export var run_speed: float = 7
@export var jump_strength: float = 30
@export var gravity: float = 1.7
@export var max_stamina: float = 100
@export var stamina_usage: float = 30
@export var stamina_recovery: float = 20
@export var jump_stamina: float = 5
@export var punch_stamina: float = 5

@export_group("Stats")
@export var damage: float = 10
@export var max_hp: float = 100
@export var defend: float = 1

@onready var sprite = $Sprite
@onready var stamina_timer = $Timers/StaminaTimer

var direction: float
var target_enemy: CharacterBody3D
var can_walk := false
var can_attack := false
var is_moving := false
var is_stamina_recovery := false
var is_punch_discard_stamina := false
var hp: float
var speed: float
var stamina: float

var damage_multiplier := 1.0
var max_health_multiplier := 1.0
var defend_multiplier := 1.0
var max_stamina_multiplier := 1.0
var speed_multiplier := 1.0

signal player_damaged(damage: float)
signal player_run(stamina: float)

func _ready() -> void:
	hp = max_hp
	speed = walk_speed
	stamina = max_stamina

func _physics_process(delta: float) -> void:
	get_input(delta)
	recover_stamina(delta)
	if can_walk:
		move()
	
func move() -> void:
	velocity.x = direction * speed
	velocity.y -= gravity
	move_and_slide()
	
func run(delta) -> void:
	if stamina > 0:
		speed = run_speed * speed_multiplier
		stamina -= stamina_usage * delta
		player_run.emit(stamina * (1.0 / get_right_max_stamina()))
		
func jump() -> void:
	if stamina >= jump_stamina and can_walk:
		velocity.y += jump_strength
		stamina -= jump_stamina
		player_run.emit(stamina * (1.0 / get_right_max_stamina()))
		is_moving = true
	
func get_input(delta) -> void:
	speed = walk_speed * speed_multiplier
	direction = Input.get_axis("left", "right")
	is_moving = direction != 0.0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_pressed("run") and direction and can_walk:
		run(delta)
		
	if Input.is_action_just_pressed("attack") and can_attack:
		if target_enemy:
			if not is_punch_discard_stamina:
				attack()
			else:
				if stamina >= punch_stamina:
					stamina -= punch_stamina
					attack()
					player_run.emit(stamina * (1.0 / get_right_max_stamina()))
	
func recover_stamina(delta) -> void:
	if not is_moving:
		if stamina_timer.is_stopped():
			stamina_timer.start()
	else:
		is_stamina_recovery = false
		stamina_timer.stop()
		
	if is_stamina_recovery and stamina < max_stamina:
		stamina += stamina_recovery * delta
		player_run.emit(stamina * (1 / get_right_max_stamina()))

func start_walking() -> void:
	can_walk = true

func start_attack() -> void:
	can_attack = true
	
func attack():
	target_enemy.get_damage(get_right_damage())

func show_sprite() -> void:
	sprite.show()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"enemy"):
		target_enemy = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == target_enemy:
		target_enemy = null

func get_damage(self_damage):
	if can_attack:
		hp -= self_damage * get_right_defend()
		player_damaged.emit(hp * (1.0 / get_right_max_health()))
		
		if hp <= 0:
			collision_layer = 2
			collision_mask = 2
			set_physics_process(false)

func add_health(value: float) -> void:
	hp += value
	
	if hp > get_right_max_health():
		hp = get_right_max_health()

func add_damage_multiplier(value: float) -> void:
	damage_multiplier += value
	
func add_speed_multiplier(value: float) -> void:
	speed_multiplier += value
	
func add_defend_multiplier(value: float) -> void:
	defend_multiplier -= value
	
func add_max_stamina_multiplier(value: float) -> void:
	max_stamina_multiplier += value
	
	if stamina > get_right_max_stamina():
		stamina = get_right_max_stamina()
	
func add_max_health_multiplier(value: float) -> void:
	max_health_multiplier += value
	
	if hp > get_right_max_health():
		hp = get_right_max_health()

func _on_stamina_timer_timeout() -> void:
	is_stamina_recovery = true
	
func get_right_max_health() -> float:
	return max_hp * max_health_multiplier
	
func get_right_max_stamina() -> float:
	return max_stamina * max_stamina_multiplier
	
func get_right_defend() -> float:
	return defend * defend_multiplier
	
func get_right_damage() -> float:
	return damage * damage_multiplier
