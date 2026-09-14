class_name LivedTime extends Control

@onready var main: PlayerNameLabel = %Main
@onready var millis: PlayerNameLabel = %Millis

@export var msec: int:
	set(value):
		set_time(value)

@export var color: Color:
	set(value):
		main.color = value
		millis.color = value

@export var font_size: int:
	set(value):
		main.add_theme_font_size_override("font_size", value)
		millis.add_theme_font_size_override("font_size", value * 0.6)

func set_time(m: int):
	var time := Globals.millis_to_string(m).split(".")
	main.text = time[0]
	millis.text = ".%s" % time[1]
