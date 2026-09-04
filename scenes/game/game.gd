extends Node

@onready var start_timer = %GameStartTimer

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _init() -> void:
	SignalBus.game_initiated.connect(on_game_initiated)

func on_game_initiated():
	Log.debug("game initiated")
	start_timer.start()

func on_start_timer_timeout():
	Log.debug("game started")
	SignalBus.game_started.emit()
