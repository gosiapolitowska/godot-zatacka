extends Node

enum PlayerModifiedType { CREATED, UPDATED }

func seconds_to_string(time_in_sec: int):
	var seconds: int = time_in_sec % 60
	var minutes: int = time_in_sec / 60

	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d" % [minutes, seconds]
