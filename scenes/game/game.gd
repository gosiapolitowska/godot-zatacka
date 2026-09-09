class_name Game extends Node

@export var game_manager: GameManager

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _ready() -> void:
	game_manager.go_to_config()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		game_manager.go_to_config()
