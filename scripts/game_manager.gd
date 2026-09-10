class_name GameManager extends Node

enum GameState { GAME_CONFIG, GAME_INITIATED, ROUND_INITIATED, ROUND_ACTIVE, ROUND_END, GAME_END }

var state_machine := StateMachine.new(GameState)
var timer: Timer
const start_wait_time := 2

@export var player_manager: PlayerManager
@export var menu: Menu
@export var config_manager: ConfigManager
@export var game_controller: GameController
@export var round_manager: RoundManager
@export var player_panel: PlayerPanel
@export var game_end_screen: GameEndEscreen

func _init() -> void:
	# map of state -> valid from
	state_machine.add_transition(GameState.GAME_CONFIG, [GameState.GAME_INITIATED, GameState.ROUND_INITIATED, GameState.ROUND_ACTIVE, GameState.ROUND_END, GameState.GAME_END])
	state_machine.add_transition(GameState.GAME_INITIATED, [GameState.GAME_CONFIG, GameState.GAME_END])
	state_machine.add_transition(GameState.ROUND_INITIATED, [GameState.GAME_INITIATED, GameState.ROUND_END])
	state_machine.add_transition(GameState.ROUND_ACTIVE, [GameState.ROUND_INITIATED])
	state_machine.add_transition(GameState.ROUND_END, [GameState.ROUND_ACTIVE])
	state_machine.add_transition(GameState.GAME_END, [GameState.ROUND_END, GameState.ROUND_ACTIVE])

func _ready() -> void:
	menu.start_game_requested.connect(initiate_game)
	game_controller.player_died.connect(_on_player_died)
	round_manager.round_finished.connect(end_round)
	round_manager.game_finished.connect(end_game)
	round_manager.player_score_updated.connect(_on_score_updated)
	player_panel.to_config_requested.connect(go_to_config)
	player_panel.next_round_requested.connect(initiate_round)
	player_panel.show_ranking_requested.connect(_on_show_ranking)
	player_panel.new_game_requested.connect(initiate_game)

func initiate_game():
	debug(" -> init game")
	if not state_machine.transition_if_valid(GameState.GAME_INITIATED):
		return
	game_end_screen.clear_and_hide()
	round_manager.new_game(player_manager.players, config_manager.round_mode, config_manager.get_config(Enums.ConfigName.ROUND_COUNT).get_value(), config_manager.max_points)
	player_panel.new_game()
	initiate_round()

func initiate_round():
	debug(" -> init round")
	if not state_machine.transition_if_valid(GameState.ROUND_INITIATED):
		return
	
	game_controller.initiate()
	round_manager.initiate_new_round()
	player_panel.new_round(round_manager.current_snapshot(), config_manager.round_mode, round_manager.current_round, round_manager.round_count, config_manager.max_points)
	#_show_countdown()
	_initiate_timer()
	
	#_initiate_player_panel()

func start_round():
	debug(" -> start round")
	if not state_machine.transition_if_valid(GameState.ROUND_ACTIVE):
		return
	round_manager.start_new_round()
	game_controller.start()
	_clear_timer()
	#_hide_countdown()

func end_round():
	debug(" -> end round")
	if not state_machine.transition_if_valid(GameState.ROUND_END):
		return

func end_game():
	debug(" -> end game")
	if not state_machine.transition_if_valid(GameState.GAME_END):
		return
	game_end_screen.set_players(round_manager.current_snapshot())
	game_end_screen.display()
	player_panel.game_end()

func go_to_config():
	debug(" -> config")
	if not state_machine.transition_if_valid(GameState.GAME_CONFIG):
		return
	_clear_timer()
	round_manager.clear()
	game_controller.clear()
	player_panel.clear()
	game_end_screen.clear_and_hide()
	menu.show_config_menu()

func _on_show_ranking():
	if state_machine.state != GameState.GAME_END:
		Log.error("[Game Manager] Can't show ranking when game state is %s" % state_machine.state)
		return
	game_end_screen.display()

func _initiate_timer():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = start_wait_time
	timer.timeout.connect(start_round)
	add_child(timer)
	timer.start()

func _clear_timer():
	if timer:
		timer.queue_free()
		timer = null

func _on_player_died(player: PlayerInfo):
	round_manager.player_died(player.id)

func _on_score_updated(players: Array[Player]):
	player_panel.update_players(players)

func debug(msg: String):
	Log.debug("[Game Manager] %s" % msg)
