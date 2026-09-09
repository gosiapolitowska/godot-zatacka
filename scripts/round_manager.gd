class_name RoundManager extends Node

signal round_finished
signal game_finished
signal player_score_updated(players: Array[Player])

var current_round := 0
var _players: Dictionary[int, Player] = {}

var round_count: int
var _player_count: int
var _active_players: int
var _round_start_time: int
var _round_mode: Enums.RoundMode
var _max_points: int

func new_game(players: Array[PlayerInfo], mode: Enums.RoundMode, round_count: int, max_points: int):
	self.round_count = round_count
	_player_count = players.size()
	_active_players = players.size()
	for player in players:
		_players[player.id] = Player.new(player)
	_round_mode = mode
	_max_points = max_points
	Log.debug("[RoundManager] new game, mode: %s, %s rounds, %s points, %s players" % [mode, round_count, _max_points, _player_count])

func player_died(id: int):
	var player := _players[id]
	if not player.alive:
		Log.error("[RoundManager] Player %s is already dead. How many times do you want to kill them?" % player.info.name)
		return
	
	_active_players -= 1
	var now_msec := Time.get_ticks_msec()
	player.kill((now_msec - _round_start_time) / 1000)
	
	for p: Player in _players.values():
		if p.alive:
			p.add_score()
	
	player_score_updated.emit(current_snapshot())
	
	if _active_players <= 0:
		if _is_end_game():
			game_finished.emit()
		else:
			round_finished.emit()

func initiate_new_round():
	current_round += 1
	_active_players = _player_count
	for player: Player in _players.values():
		player.revive()
	
func start_new_round():
	_round_start_time = Time.get_ticks_msec()

func clear():
	_players.clear()
	current_round = 0

func current_snapshot() -> Array[Player]:
	var copy: Array[Player] = []
	for player: Player in _players.values():
		copy.append(player.copy())
	return copy

func _is_end_game() -> bool:
	match _round_mode:
		Enums.RoundMode.FIXED_ROUNDS:
			return current_round >= round_count
		Enums.RoundMode.FIXED_POINTS:
			return _players.values().any(func(p: Player): return p.score >= _max_points)
		var m:
			Log.error("[RoundManager] unexpected round mode %s" % m)
			return false
