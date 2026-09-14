class_name CrashAnimationComponent extends Node

@export var _obj: Node2D
@export var _animation_time := 0.5
@export var _size: float
@export var _max_size := 76.0

func with_values(obj: Node2D, size: int) -> CrashAnimationComponent:
	_obj = obj
	_size = float(size)
	return self

func _ready() -> void:
	animate()

func animate():
	var scale := _max_size / _size
	var tween := create_tween()
	var alpha_tween = create_tween()
	alpha_tween.tween_property(_obj, "modulate:a", 0.0, _animation_time)
	tween.tween_property(_obj, "scale", Vector2(scale, scale), 0.5 * _animation_time)
	tween.tween_property(_obj, "scale", Vector2(0.5, 0.5), 0.5 * _animation_time)
	tween.tween_callback(_cleanup)

func _cleanup():
	_obj.queue_free()
	queue_free()
