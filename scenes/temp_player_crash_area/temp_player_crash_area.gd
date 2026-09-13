class_name CrashArea
extends StaticBody2D

var _from: Vector2
var _to: Vector2
var _initial_delay: float
var _timer: Timer

func _init() -> void:
	collision_layer = 2

func with_values(from: Vector2, to: Vector2, initial_delay: float) -> CrashArea:
	_from = from
	_to = to
	_initial_delay = initial_delay * 1.1
	return self

func _ready() -> void:
	var shape = SegmentShape2D.new()
	shape.a = _from
	shape.b = _to
	
	var c = CollisionShape2D.new()
	c.shape = shape
	add_child(c)
	
	_timer = Timer.new()
	_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	_timer.one_shot = true
	_timer.wait_time = _initial_delay
	_timer.autostart = true
	_timer.timeout.connect(_on_activation)
	add_child(_timer)

func _on_activation() -> void:
	if collision_layer != 1:
		set_deferred("collision_layer", 1)
	if _timer:
		_timer.queue_free()
