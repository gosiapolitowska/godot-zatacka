extends Control

func _draw() -> void:
	var step = 1.0/12.0
	var angle = Vector2.UP.angle() + TAU * step
	var angle2 = Vector2.UP.rotated(TAU * step).angle()
	Log.debug("[Sandbox] angle = %s, angle2 = %s" % [angle, angle2])
	draw_arc(Vector2(100, 100), 50, Vector2.UP.angle(), angle, 100, Color.CHARTREUSE, 10, true)
	draw_arc(Vector2(200, 100), 50, Vector2.UP.angle(), angle2, 100, Color.CHARTREUSE, 10, true)
