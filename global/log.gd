extends Node

func debug(msg: String):
	print("[%s] %s" % [Time.get_datetime_string_from_system(), msg])

func warn(msg: String):
	push_warning("[%s] %s" % [Time.get_datetime_string_from_system(), msg])

func error(msg: String):
	push_error("[%s] %s" % [Time.get_datetime_string_from_system(), msg])
