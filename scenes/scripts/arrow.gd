extends Node3D

@export_group("ArrowStat")
@export var speed: float = 16
@export var gravitation_strength: float = 0.05
@export var damage: float = 15

@onready var sprite = $Sprite
@onready var arrow_sound = $ArrowSound

var target_position
var to_player: Vector2
var player
var direction: Vector2
var gravity: float

func _ready() -> void:
	arrow_sound.volume_db = GlobalSounds.min_sfx_db_sound + GlobalSounds.sfx_loud * 25
	arrow_sound.play()

func setup(spawn_position, target) -> void:
	target_position = target.global_position + Vector3(0, 1.6, 0)
	player = target
	
	to_player.x = target_position.x  - spawn_position.x
	to_player.y = target_position.y - spawn_position.y
	
	direction = to_player.normalized()
	rotation.z = to_player.angle()
	
	position.x = spawn_position.x + direction.x * 0.5
	position.y = spawn_position.y + direction.y * 0.5
	
func _physics_process(delta: float) -> void:
	gravity += gravitation_strength * delta
	if direction:
		position.x += direction.x * speed * delta
		position.y += direction.y * speed * delta - gravity
	rotation.z -= gravitation_strength * delta * (TAU if direction.x > 0 else -TAU)

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player.get_damage(damage)
	queue_free()
