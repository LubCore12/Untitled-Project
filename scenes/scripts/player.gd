extends CharacterBody2D

@export_group("Movement")
@export var speed: float
@export var run_speed: float

var direction: Vector2
var current_speed = speed

signal player_attacked(damage)

func _physics_process(delta: float) -> void:
	print(position)
	get_input(delta)
	move()
	
func move() -> void:
	velocity = direction * current_speed
	move_and_slide()

func run() -> void:
	current_speed = run_speed
	
func get_input(_delta) -> void:
	if Input.is_action_pressed("run"):
		run()
	var x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	var y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_undo")
	direction = Vector2(x,y).normalized()
	
	if Input.is_action_just_pressed("attack"):
		player_attacked.emit()
