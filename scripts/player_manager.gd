class_name PlayerManager extends Node

var players: Array[PlayerInfo] = []

@export var config_manager: ConfigManager
var _player_count_config: IntConfigValue

func _ready() -> void:
	_player_count_config = config_manager.get_config(Enums.ConfigName.PLAYER_COUNT)
	Log.debug("[PlayerManager] Creating %s players" % _player_count_config.get_value())
	for i in range(_player_count_config.get_value()):
		players.append(PlayerInfo.new(i, config_manager.default_colors[i], config_manager.default_names[i], i, config_manager.action_bindings[i]))

func remove_player(id: int) -> bool:
	if players.size() <= _player_count_config.get_min_value():
		Log.error("[PlayerManager] Player count can't drop below %s, not removing %d" % [_player_count_config.get_min_value(), id])
		return false
	var index = players.find_custom(func(p: PlayerInfo): return p.id == id)
	if index < 0:
		Log.error("[PlayerManager] Trying to remove non-existing player id %s" % id)
		return false
	players.remove_at(index)
	_update_player_count(players.size())
	return true

func add_player() -> PlayerInfo:
	var size = players.size()
	if size >= _player_count_config.get_max_value():
		Log.error("[PlayerManager] Player count can't go above %s, not adding" % [_player_count_config.get_max_value()])
		return null
	var current_names = players.map(func(p: PlayerInfo): return p.name)
	var current_bindings = players.map(func(p: PlayerInfo): return p.binding_index)
	var current_ids = players.map(func(p: PlayerInfo): return p.id)
	var current_colors = players.map(func(p: PlayerInfo): return p.color)
	var name = _first_available(config_manager.default_names, current_names)
	var binding_index = _first_available(range(size + 1), current_bindings)
	var id = _first_available(range(size + 1), current_ids)
	var color = _first_available(config_manager.default_colors, current_colors)
	var new_player = PlayerInfo.new(id, color, name, binding_index, config_manager.action_bindings[binding_index])
	Log.debug("[PlayerManager] adding player %s" % [new_player])
	players.append(new_player)
	_update_player_count(players.size())
	return new_player

func update_player(player: PlayerInfo):
	var index = players.find_custom(func(p: PlayerInfo): return p.id == player.id)
	if index < 0:
		Log.error("[PlayerManager] Couldn't find player %s, not updating" % [player])
		return
	players[index] = player

func _first_available(arr: Array, current: Array) -> Variant:
	for x in arr:
		if x not in current:
			return x
	return null

func _update_player_count(count: int):
	config_manager.update_config(Enums.ConfigName.PLAYER_COUNT, count)

func validate() -> Array[String]:
	var errors: Array[String] = []
	
	if _is_not_unique(players, func(player: PlayerInfo): return player.binding_index):
		errors.append("All players must have unique key bindings")
	
	if _is_not_unique(players, func(player: PlayerInfo): return player.color):
		errors.append("All players must have unique colors")

	return errors

func _is_not_unique(players: Array[PlayerInfo], field_extractor: Callable) -> bool:
	var dict = {}
	players.map(func(item): dict[field_extractor.call(item)] = 1)
	return dict.size() != players.size()
