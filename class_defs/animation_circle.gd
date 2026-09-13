class_name AnimationCircle extends Sprite2D

@export var color: Color = Color.CHARTREUSE:
	set(value):
		color = value
		queue_redraw()

@export var size: int = 8:
	set(value):
		size = value
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, size / 2, color, false, 3.0, true)
