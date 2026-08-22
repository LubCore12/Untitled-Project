extends CharacterBody2D

@export_group("Movement")
@export var speed: float
@export var run_speed: float
@export var hp: float
@export var damage: float

var enimy_scene := preload("res://scenes/enimy.tscn")
var target_enimy: CharacterBody2D
var direction: Vector2
var current_speed: float

func _ready() -> void:
	current_speed = speed

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func get_input(_delta) -> void:
	current_speed = speed
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("run"):
		run()
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack() -> void:
	if target_enimy:
		target_enimy.get_damage(damage)
	
func move() -> void:
	velocity = direction * current_speed
	move_and_slide()

func run() -> void:
	current_speed = run_speed

func get_damage(self_damage):
	hp -= self_damage
	print(hp)
	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self:
		target_enimy=body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target_enimy:
		target_enimy = null
