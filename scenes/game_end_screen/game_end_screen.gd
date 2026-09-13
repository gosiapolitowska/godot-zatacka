class_name GameEndEscreen extends Node

@export var ui: GameEndUi
@export var config_manager: ConfigManager

func set_players(players: Array[Player]):
	var p = players.duplicate()
	p.sort_custom(_sort_by_score_and_msec_lived)
	_populate_places(p)
	ui.update(p, config_manager.nth)

func display():
	ui.show()

func clear_and_hide():
	ui.clear()
	ui.hide()

func _sort_by_score_and_msec_lived(p1: Player, p2: Player) -> bool:
	if p1.score == p2.score:
		return p1.max_msec_lived >= p2.max_msec_lived
	return p1.score > p2.score

func _populate_places(players: Array[Player]):
	var place := 1
	var place_score := players[0].score
	for p: Player in players:
		if p.score < place_score:
			place += 1
		p.place = place
