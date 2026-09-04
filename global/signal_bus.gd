extends Node

signal collided(id: int)
signal game_initiated
signal player_count_selected(count: int)
signal players_modified(type: Globals.PlayerModifiedType)
signal game_started
signal game_stopped
signal esc_pressed
signal player_moved(from: Vector2, to: Vector2, player_color: Color)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		esc_pressed.emit()
