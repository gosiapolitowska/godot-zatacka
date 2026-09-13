extends Node

func debug(msg: String):
	print("[%s] %s" % [_current_datetime(), msg])

func warn(msg: String):
	push_warning("[%s] %s" % [_current_datetime(), msg])

func error(msg: String):
	push_error("[%s] %s" % [_current_datetime(), msg])

func _current_datetime() -> String:
	var millis = fmod(Time.get_ticks_msec(), 1000)
	return "%s.%03d" % [Time.get_datetime_string_from_system(), millis]
