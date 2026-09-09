extends Node

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var paused := not get_tree().paused
		Log.debug("[Debug] Toggle paused to %s" % paused)
		get_tree().paused = paused
