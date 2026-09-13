class_name Dot
extends Area2D

signal collided(player: PlayerInfo)
signal moved(from: Vector2, to: Vector2, player: PlayerInfo)

@onready var collision = $DotCollision
@onready var circle = $DotCircle

var _speed: int
var _rotation_radius: int
var _player_size: int
var _player_info: PlayerInfo

var _rotation_direction := 0.0
var _moving = false

func with_values(dot_config: DotConfig, player_info: PlayerInfo) -> Dot:
	_speed = dot_config.speed
	_rotation_radius = dot_config.rotation_radius
	_player_size = dot_config.player_size
	_player_info = player_info
	return self

func _ready() -> void:
	collision.size = _player_size
	circle.size = _player_size
	circle.color = _player_info.color

func _process(delta: float) -> void:
	if not _moving:
		return
	_rotation_direction = Input.get_axis(_player_info.actions[0], _player_info.actions[1])
	rotation += _rotation_direction * (_speed / _rotation_radius) * delta
	
	var velocity = Vector2.RIGHT * _speed * delta
	var old_position = position
	position += velocity.rotated(rotation)
	
	moved.emit(old_position, position, _player_info)

func _on_area_entered(_area: Area2D) -> void:
	if _moving:
		collided.emit(_player_info)
		_moving = false
	queue_free()

func stop():
	_moving = false
	queue_free()

func start():
	_moving = true
