class_name Menu extends Node

@export var ui: Ui
@export var config_manager: ConfigManager
@export var player_manager: PlayerManager

signal start_game_requested

func _ready() -> void:
	var count_config = config_manager.get_config(Enums.ConfigName.PLAYER_COUNT)
	ui.initialize(\
		count_config.get_min_value(),\
		count_config.get_max_value(),\
		config_manager.action_bindings,\
		config_manager.round_mode,\
		config_manager.max_points\
	)
	ui.start_game_pressed.connect(_on_start_button_pressed)
	ui.points_changed.connect(_on_points_changed)
	ui.round_mode_changed.connect(_on_round_mode_changed)
	ui.add_player_clicked.connect(_on_add_player)
	ui.remove_player_clicked.connect(_on_remove_player)
	ui.player_updated.connect(_on_player_updated)
	_add_config_option(Enums.ConfigName.SPEED)
	_add_config_option(Enums.ConfigName.ROTATION_SPEED)
	_add_config_option(Enums.ConfigName.PLAYER_SIZE)
	var callback = func(value): config_manager.update_config(Enums.ConfigName.ROUND_COUNT, value)
	ui.configure_round_option(config_manager.get_config(Enums.ConfigName.ROUND_COUNT), callback)

func show_config_menu():
	ui.update(player_manager.players)
	ui.show()

func _add_config_option(name: Enums.ConfigName):
	var on_value_changed: Callable = func(value): config_manager.update_config(name, value)
	ui.add_config_option(config_manager.get_config(name), on_value_changed)

func _on_add_player():
	var player = player_manager.add_player()
	if player:
		ui.add_player(player)

func _on_player_updated(player: PlayerInfo):
	player_manager.update_player(player)

func _on_remove_player(id: int):
	Log.debug("[Menu] trying to remove player %s" % [id])
	if player_manager.remove_player(id):
		ui.remove_player(id)

func _on_points_changed(value: int):
	Log.debug("[Menu] trying to update max points to %s" % value)
	if value >= 0:
		Log.debug("[Menu] updating max points to %s" % value)
		config_manager.max_points = value

func _on_round_mode_changed(mode: Enums.RoundMode):
	config_manager.round_mode = mode

func _on_player_count_selected(count: int):
	config_manager.update_config(Enums.ConfigName.PLAYER_COUNT, count)
	ui.update(player_manager.recreate_players())

func _on_start_button_pressed() -> void:
	var errors := player_manager.validate()
	if errors.is_empty():
		ui.hide()
		start_game_requested.emit()
	else:
		ui.display_errors(errors)
