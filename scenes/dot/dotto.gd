class_name Dotto extends CharacterBody2D

signal collided(player: PlayerInfo)
signal moved(from: Vector2, to: Vector2, player: PlayerInfo)

@onready var collision = %DotCollision
@onready var circle: Sprite2D = %DotCircle

var _speed: int
var _rotation_radius: int
var _player_size: int
var _player_info: PlayerInfo

var _moving := false
var _old_position: Vector2

@export var _animation_size := 50
@export var _animation_scale := 10.0

func with_values(dot_config: DotConfig, player_info: PlayerInfo) -> Dotto:
	_speed = dot_config.speed
	_rotation_radius = dot_config.rotation_radius
	_player_size = dot_config.player_size
	_player_info = player_info
	return self

func _ready() -> void:
	collision.size = _player_size
	circle.size = _player_size
	circle.color = _player_info.color
	_old_position = position
	_spawn_animation()

func _physics_process(delta: float) -> void:
	if not _moving:
		return
	
	var rotation_direction = Input.get_axis(_player_info.actions[0], _player_info.actions[1])
	rotation += rotation_direction * (_speed / _rotation_radius) * delta
	
	var v = Vector2.RIGHT * _speed * delta
	
	if _old_position != position:
		moved.emit(_old_position, position, _player_info)
	_old_position = position
	
	var collision = move_and_collide(v.rotated(rotation))
	if collision:
		_on_crash()

func stop():
	_moving = false
	queue_free()

func start():
	_moving = true

func _spawn_animation():
	var circle_copy := circle.duplicate()
	_add_animation(circle_copy)
	
	var animation_circle = AnimationCircle.new()
	animation_circle.color = _player_info.color
	animation_circle.size = _animation_size
	_add_animation(animation_circle)

func _add_animation(obj: Sprite2D):
	var animation = AnimationComponent.new().with_values(self, obj, _animation_scale)
	add_child(animation)

func _on_crash() -> void:
	if _moving:
		if _old_position != position:
			moved.emit(_old_position, position, _player_info)
		collided.emit(_player_info)
		_moving = false
	queue_free()
