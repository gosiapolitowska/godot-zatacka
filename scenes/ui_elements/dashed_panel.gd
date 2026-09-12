class_name DashedPanel extends Control

@export var border_width: float = 1.0:
	set(value):
		border_width = value
		queue_redraw()

@export var border_color: Color = Color.BLACK:
	set(value):
		border_color = value
		queue_redraw()

@export var corner_radius: float = 8.0:
	set(value):
		corner_radius = value
		queue_redraw()

@export var dash_length: float = 6.0:
	set(value):
		dash_length = value
		queue_redraw()

@export var dash_space_ratio: float = 1.0:
	set(value):
		dash_space_ratio = value
		queue_redraw()

const CORNER_SEGMENTS := 16

func _ready() -> void:
	resized.connect(queue_redraw)

func _draw() -> void:
	_draw_dashed_polyline(_get_rounded_rect_outline())

func _get_rounded_rect_outline() -> PackedVector2Array:
	var r := clampf(corner_radius, 0.0, minf(size.x, size.y) / 2.0)
	var points := PackedVector2Array()

	var corners := [
		{"center": Vector2(r, r), "start": PI, "end": PI * 1.5},
		{"center": Vector2(size.x - r, r), "start": PI * 1.5, "end": PI * 2.0},
		{"center": Vector2(size.x - r, size.y - r), "start": 0.0, "end": PI * 0.5},
		{"center": Vector2(r, size.y - r), "start": PI * 0.5, "end": PI},
	]

	for corner in corners:
		for i in range(CORNER_SEGMENTS + 1):
			var t := float(i) / float(CORNER_SEGMENTS)
			var angle: float = lerpf(corner["start"], corner["end"], t)
			points.append(corner["center"] + Vector2(cos(angle), sin(angle)) * r)

	points.append(points[0])
	return points

func _draw_dashed_polyline(points: PackedVector2Array) -> void:
	if dash_length <= 0.0:
		draw_polyline(points, border_color, border_width)
		return

	var gap_length := dash_length * dash_space_ratio
	var dash_on := true
	var remaining := dash_length

	for i in range(points.size() - 1):
		var p0 := points[i]
		var p1 := points[i + 1]
		var seg_len := p0.distance_to(p1)
		var pos := 0.0

		while pos < seg_len:
			var step: float = minf(remaining, seg_len - pos)
			if dash_on:
				var a := p0.lerp(p1, pos / seg_len)
				var b := p0.lerp(p1, (pos + step) / seg_len)
				draw_line(a, b, border_color, border_width)
			pos += step
			remaining -= step
			if remaining <= 0.0:
				dash_on = not dash_on
				remaining = dash_length if dash_on else gap_length
