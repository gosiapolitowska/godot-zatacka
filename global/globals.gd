extends Node

enum PlayerModifiedType { CREATED, UPDATED }

func millis_to_string(time_in_msec: int) -> String:
	var time = time_in_msec
	var millis := time_in_msec % 1000
	time = time / 1000
	var seconds: int = time % 60
	var minutes: int = time / 60

	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d.%03d" % [minutes, seconds, millis]
