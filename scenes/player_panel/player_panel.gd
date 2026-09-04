extends Panel

@onready var active_players_container = %ActivePlayerContainer
@onready var dead_players_container = %DeadPlayerContainer

func _init() -> void:
	SignalBus.players_modified.connect(on_players_modified)

func on_players_modified(_type: Globals.PlayerModifiedType):
	redraw_players()

func redraw_players():
	for child in active_players_container.get_children():
		child.queue_free()
	for child in dead_players_container.get_children():
		child.queue_free()
	
	var alive_players = PlayerManager.players.filter(func(player: PlayerInfo): return player.alive)
	for player in alive_players:
		var panel = preload("res://scenes/active_player_info_box/active_player_info_box.tscn").instantiate()
		panel.player_info = player
		active_players_container.add_child(panel)
	
	var dead_players = PlayerManager.players.filter(func(player: PlayerInfo): return not player.alive)
	dead_players.sort_custom(func(p1: PlayerInfo, p2: PlayerInfo): return p1.place < p2.place)
	for player in dead_players:
		var panel = preload("res://scenes/dead_player_info_box/dead_player_info_box.tscn").instantiate()
		panel.player_info = player
		dead_players_container.add_child(panel)
