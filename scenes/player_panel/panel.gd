class_name PanelUi extends Panel

signal next_round_clicked
signal menu_clicked
signal ranking_clicked
signal replay_clicked

const ACTIVE_PLAYER = preload("res://scenes/active_player_info_box/active_player_info_box.tscn")
const DEAD_PLAYER = preload("res://scenes/dead_player_info_box/dead_player_info_box.tscn")

@onready var active_players_container = %ActivePlayerContainer
@onready var dead_players_container = %DeadPlayerContainer
@onready var round_label: Label = %RoundLabel
@onready var round_indicator: PointIndicator = %RoundIndicator
@onready var ranking_button: Button = %RankingButton
@onready var next_round_button: Button = %NextRoundButton
@onready var menu_button: Button = %MenuButton
@onready var quit_button: Button = %QuitButton
@onready var replay_button: Button = %ReplayButton

var _max_points: int

func _ready() -> void:
	next_round_button.pressed.connect(func(): next_round_clicked.emit())
	menu_button.pressed.connect(func(): menu_clicked.emit())
	quit_button.pressed.connect(_on_quit_button_pressed)
	ranking_button.pressed.connect(func(): ranking_clicked.emit())
	replay_button.pressed.connect(func(): replay_clicked.emit())
	
func new_game():
	ranking_button.hide()
	replay_button.hide()
	next_round_button.show()

func new_round(mode: Enums.RoundMode, current_round: int, round_count: int, max_points: int):
	_update_round_label(mode, current_round, round_count)
	_max_points = max_points

func game_end():
	ranking_button.show()
	replay_button.show()
	next_round_button.hide()

func clear_players():
	clear_active_players()
	clear_dead_players()

func clear_active_players():
	for child in active_players_container.get_children():
		child.queue_free()

func clear_dead_players():
	for child in dead_players_container.get_children():
		child.queue_free()

func draw_active_players(players: Array[Player]):
	for player in players:
		var panel = (ACTIVE_PLAYER.instantiate() as ActivePlayerInfo).with_values(_max_points, player)
		active_players_container.add_child(panel)

func redraw_active_players(players: Array[Player]):
	clear_active_players()
	draw_active_players(players)

func redraw_dead_player(players: Array[Player]):
	clear_dead_players()
	for player: Player in players:
		var panel = (DEAD_PLAYER.instantiate() as DeadPlayerInfo).with_values(_max_points, player)
		dead_players_container.add_child(panel)
		dead_players_container.move_child(panel, 0)

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _update_round_label(mode: Enums.RoundMode, current_round: int, round_count: int):
	if mode == Enums.RoundMode.FIXED_ROUNDS:
		round_label.text = "Round"
		round_indicator.show()
		round_indicator.configure(round_count, Color.GREEN_YELLOW)
		round_indicator.update_points(current_round)
	else:
		round_label.text = "Round %s" % current_round
		round_indicator.hide()
