extends Node

var players: Array[PlayerInfo] = []
var active_players: int = 0
var game_started_time: int = 0

func _init() -> void:
	SignalBus.player_count_selected.connect(on_player_count_selected)
	SignalBus.collided.connect(on_player_collided)
	SignalBus.esc_pressed.connect(on_esc_pressed)
	SignalBus.game_started.connect(on_game_started)

func on_game_started():
	game_started_time = Time.get_ticks_msec()
	
func on_esc_pressed() -> void:
	revive_players()
	SignalBus.players_modified.emit(Globals.PlayerModifiedType.UPDATED)

func on_player_count_selected(count: int):
	revive_players()
	for i in range(count):
		if (players.size() <= i):
			players.append(PlayerInfo.new(i, Globals.default_colors[i], Globals.default_names[i], i))
	players.resize(count)
	active_players = count
	SignalBus.players_modified.emit(Globals.PlayerModifiedType.CREATED)

func on_player_collided(id: int):
	var current_time = Time.get_ticks_msec()
	var player = players[id]
	Log.debug("Player %s collided, killing" % player)
	player.kill(active_players, (current_time - game_started_time) / 1000)
	active_players -= 1
	SignalBus.players_modified.emit(Globals.PlayerModifiedType.UPDATED)
	if active_players <= 0:
		SignalBus.game_stopped.emit()

func revive_players():
	for player in players:
		player.revive()
	active_players = players.size()
