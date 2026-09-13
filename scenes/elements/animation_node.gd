class_name AnimationComponent extends Node

@export var _obj: Node2D
@export var _parent: Node2D
@export var _animation_time := 0.7
@export var _alpa_animation_time_ratio := 0.2
@export var _initial_scale := 10.0

func with_values(parent: Node2D, obj: Node2D, initial_scale: float) -> AnimationComponent:
	_parent = parent
	_obj = obj
	_initial_scale = initial_scale
	return self

func _ready() -> void:
	animate()

func animate():
	var scale_tween := create_tween()
	var alpha_tween := create_tween()
	_obj.modulate.a = 0.0
	_obj.scale = Vector2(_initial_scale, _initial_scale)
	_parent.add_child(_obj)
	scale_tween.tween_property(_obj, "scale", Vector2(1.0, 1.0), _animation_time)
	scale_tween.tween_callback(_cleanup)
	alpha_tween.tween_property(_obj, "modulate:a", 1.0, _alpa_animation_time_ratio * _animation_time)
	alpha_tween.tween_property(_obj, "modulate:a", 0.0, (1.0 - _alpa_animation_time_ratio) * _animation_time)

func _cleanup():
	_obj.queue_free()
	queue_free()
