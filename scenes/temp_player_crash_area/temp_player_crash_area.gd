class_name CrashArea
extends Area2D

var from: Vector2
var to: Vector2

func _init() -> void:
	collision_layer = 2

func _ready() -> void:
	#Log.debug("ready to draw new line from %s to %s" % [from, to])
	var shape = SegmentShape2D.new()
	shape.a = from
	shape.b = to
	
	var c = CollisionShape2D.new()
	c.shape = shape
	
	add_child(c)

func on_area_exited(_area: Area2D) -> void:
	#Log.debug("area exited, enabling %s to %s" % [from, to])
	if collision_layer != 1:
		set_deferred("collision_layer", 1)
