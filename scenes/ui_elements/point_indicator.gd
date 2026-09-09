class_name PointIndicator extends Control

@onready var ring = %Ring

func configure(max_points: int, color: Color) -> PointIndicator:
	Log.debug("[PointIndicator] conf")
	ring.configure(max_points, color)
	return self

func update_points(points: int):
	ring.update_points(points)
