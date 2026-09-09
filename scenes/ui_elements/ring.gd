class_name Ring extends Control

@onready var label: Label = %Label

var radius := 20.0
var line_width := 1.0
var inner_width := 7.0

var pos := 0.0
var pos_v := Vector2.ZERO

#var inner_color := Color("73cd4bff")
var inner_color := Color("88e060ff")

#var p_outer_color := Color("47832cff")
var p_outer_color := Color.BLACK
var outer_color := Color("5fb13aff")

var max_points: int
var point_color: Color

var points: int

func configure(max_points: int, color: Color):
	self.max_points = max_points
	self.point_color = color
	label.add_theme_color_override("font_color", point_color)

func update_points(points: int):
	self.points = points
	queue_redraw()

func _draw() -> void:
	label.text = str(points)
	draw_circle(pos_v, radius, p_outer_color, false, line_width, true)
	
	var c1_pos = Vector2(pos, pos - radius)
	_draw_small_circle(c1_pos)
	
	if points <= 0:
		return
	
	if points >= max_points:
		draw_circle(pos_v, radius, p_outer_color, false, inner_width + 2 * line_width, true)
		draw_circle(pos_v, radius, point_color, false, inner_width, true)
		return
	
	var step := float(points) / float(max_points)
	var angle := Vector2.UP.angle() + step * TAU
	
	_draw_small_circle(Vector2.UP.rotated(step * TAU) * radius)
	
	var outer_arc_offset := 0.01 * TAU
	draw_arc(pos_v, radius, Vector2.UP.angle() + outer_arc_offset, angle - outer_arc_offset, 100, p_outer_color, inner_width + 2 * line_width, true)
	draw_arc(pos_v, radius, Vector2.UP.angle(), angle, 100, point_color, inner_width, true)
	
func _draw_small_circle(pos: Vector2):
	draw_circle(pos, inner_width / 2 + line_width, p_outer_color, true, -1, true)
	draw_circle(pos, inner_width / 2, point_color, true, -1, true)
