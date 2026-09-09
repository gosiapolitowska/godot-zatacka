class_name PlayerManager extends Node

var players: Array[PlayerInfo] = []

@export var config_manager: ConfigManager

func _ready() -> void:
	var count = config_manager.get_config(Enums.ConfigName.PLAYER_COUNT).get_value()
	Log.debug("[PlayerManager] Creating %s players" % count)
	for i in range(count):
		players.append(PlayerInfo.new(i, config_manager.default_colors[i], config_manager.default_names[i], i, config_manager.action_bindings[i]))

func recreate_players() -> Array[PlayerInfo]:
	var count = config_manager.get_config(Enums.ConfigName.PLAYER_COUNT).get_value()
	Log.debug("[PlayerManager] Recreating %s players" % count)
	for i in range(count):
		if (players.size() <= i):
			players.append(PlayerInfo.new(i, config_manager.default_colors[i], config_manager.default_names[i], i, config_manager.action_bindings[i]))
	players.resize(count)
	return players

func update_if_valid(incoming: Array[PlayerInfo]) -> Array[String]:
	var errors: Array[String] = []
	if players.size() != incoming.size():
		var err = "Player count doesn't match: current size: %s, incoming size: %s" % [players.size(), incoming.size()]
		Log.error("[PlayerManager] %s" % err)
		errors.append(err)
		return errors
	
	if _is_not_unique(players, func(player: PlayerInfo): return player.binding_index):
		errors.append("All players must have unique key bindings")
	
	if _is_not_unique(players, func(player: PlayerInfo): return player.color):
		errors.append("All players must have unique colors")
	
	if errors.is_empty():
		players = incoming
	return errors

func _is_not_unique(players: Array[PlayerInfo], field_extractor: Callable) -> bool:
	var dict = {}
	players.map(func(item): dict[field_extractor.call(item)] = 1)
	return dict.size() != players.size()
