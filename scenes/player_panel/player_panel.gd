class_name PlayerPanel extends Control

signal to_config_requested
signal next_round_requested

@export var ui: PanelUi

func _ready() -> void:
	ui.menu_clicked.connect(func(): to_config_requested.emit())
	ui.next_round_clicked.connect(func(): next_round_requested.emit())

func new_round(players: Array[Player], mode: Enums.RoundMode, current_round: int, round_count: int, max_points: int):
	ui.clear_players()
	ui.new_round(mode, current_round, round_count, _determine_max_points(players, mode, round_count, max_points))
	ui.draw_active_players(players)

func update_players(players: Array[Player]):
	var active := players.filter(func(p: Player): return p.alive)
	active.sort_custom(_sort_by_score)
	ui.redraw_active_players(active)
	
	var sleeping := players.filter(func(p: Player): return not p.alive)
	sleeping.sort_custom(_sort_by_score)
	ui.redraw_dead_player(sleeping)

func clear():
	ui.clear_players()

func _sort_by_score(p1: Player, p2: Player) -> bool:
	return p1.score <= p2.score

func _determine_max_points(players: Array[Player], mode: Enums.RoundMode, round_count: int, max_points: int) -> int:
	match mode:
		Enums.RoundMode.FIXED_ROUNDS:
			return (players.size() - 1) * round_count
		Enums.RoundMode.FIXED_POINTS:
			return max_points
		_:
			Log.error("[PlayerPanel] unexpected round mode %s" % mode)
			return 0
