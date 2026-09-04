extends Node2D

var color: Color = Color.CHARTREUSE:
	set(value):
		color = value
		queue_redraw()

var size: int = 8:
	set(value):
		size = value
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, size / 2, color)
