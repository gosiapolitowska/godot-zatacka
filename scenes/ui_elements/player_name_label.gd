class_name PlayerNameLabel extends Label

@export var color: Color:
	set(value):
		add_theme_color_override("font_color", value)
