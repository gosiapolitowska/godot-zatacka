class_name Dot
extends Area2D

@onready var collision = $DotCollision
@onready var circle = $DotCircle

@onready var speed = Globals.speed
@onready var rotation_speed = Globals.rotation_speed
@onready var size: int = Globals.player_size
var rotation_direction = 0

var player_info: PlayerInfo
var moving = false

func _ready() -> void:
	collision.size = size
	circle.size = size
	circle.color = player_info.color

func _process(delta: float) -> void:
	if not moving:
		return
	rotation_direction = Input.get_axis("left_%s" % player_info.keys_index, "right_%s" % player_info.keys_index)
	rotation += rotation_direction * rotation_speed * delta
	
	var velocity = Vector2.RIGHT * speed * delta
	var old_position = position
	position += velocity.rotated(rotation)
	
	SignalBus.player_moved.emit(old_position, position, player_info.color)

func _on_area_entered(_area: Area2D) -> void:
	if moving:
		SignalBus.collided.emit(player_info.id)
		moving = false
	queue_free()

func stop():
	moving = false
	queue_free()

func start():
	moving = true
