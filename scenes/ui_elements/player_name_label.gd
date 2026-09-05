extends Label

var color: Color:
	set(value):
		add_theme_color_override("font_color", value)
