extends CharacterBody2D

@export_group("Movement")
@export var speed: float
@export var run_speed: float

var direction: Vector2
var current_speed: float

signal player_attacked(damage)

func _ready() -> void:
	current_speed = speed

func _physics_process(delta: float) -> void:
	print(position)
	get_input(delta)
	move()
	
func get_input(_delta) -> void:
	current_speed = speed
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("run"):
		run()
	
	if Input.is_action_just_pressed("attack"):
		player_attacked.emit()

func move() -> void:
	velocity = direction * current_speed
	move_and_slide()

func run() -> void:
	current_speed = run_speed
