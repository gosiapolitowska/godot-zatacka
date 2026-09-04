extends Node2D

var from = Vector2(30, 30)
var to = from

func _draw() -> void:
	if from != to:
		draw_line(from, to, Color.DEEP_PINK, 8.0)
