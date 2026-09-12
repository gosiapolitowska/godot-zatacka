class_name Ui extends Control

signal start_game_pressed
signal add_player_clicked
signal add_bot_clicked
signal remove_player_clicked(id: int)
signal player_updated(player: PlayerInfo)
signal round_mode_changed(mode: Enums.RoundMode)
signal points_changed(value: int)

const PLAYER_INFO_CONTAINER = preload("res://scenes/player_info_container/player_info_container.tscn")
const CONFIG_OPTION = preload("res://scenes/ui_elements/config_option.tscn")

@onready var start_button: Button = %StartButton
@onready var alert = %Alert
@onready var option_container = %OptionContainer
@onready var player_grid = %PlayerConfigGrid
@onready var fixed_rounds_container: ConfigOption = %FixedRoundsContainer
@onready var fixed_points_container = %FixedPointsContainer
@onready var fixed_rounds_label: Label = %FixedRoundsLabel
@onready var fixed_points_label: Label = %FixedPointsLabel
@onready var round_mode_button: Button = %RoundModeToggleButton
@onready var points_spin: SpinBox = %PointsSpinBox
@onready var add_player_container = %AddPlayerContainer
@onready var add_player_button: Button = %AddPlayerButton
@onready var add_bot_button: Button = %AddBotButton

var _min_player_count: int
var _max_player_count: int
var _bindings: Array[Array]

var _player_info_containers: Array[PlayerInfoContainer] = []
var _round_mode: Enums.RoundMode
var _disabled_color := Color("636363")

func initialize(\
	min_player_count:\
	int, max_player_count: int,\
	bindings: Array[Array],\
	round_mode: Enums.RoundMode,\
	max_poins: int\
):
	_min_player_count = min_player_count
	_max_player_count = max_player_count
	_bindings = bindings
	debug("inited with min %s, max %s" % [_min_player_count, _max_player_count])
	
	player_grid.columns = _max_player_count
	start_button.pressed.connect(func(): start_game_pressed.emit())
	
	_update_round_mode(round_mode)
	round_mode_button.pressed.connect(_toggle_round_mode)
	points_spin.set_value_no_signal(max_poins)
	points_spin.value_changed.connect(func(value): points_changed.emit(value))
	
	add_player_button.pressed.connect(func(): add_player_clicked.emit())
	add_bot_button.pressed.connect(func(): add_bot_clicked.emit())

func update(players: Array[PlayerInfo]):
	for c in _player_info_containers:
		c.queue_free()
	_player_info_containers.clear()
	for player in players:
		add_player(player)

func add_player(player: PlayerInfo):
	var c = (PLAYER_INFO_CONTAINER.instantiate() as PlayerInfoContainer).with_values(player, _bindings)
	_player_info_containers.append(c)
	player_grid.add_child(c)
	c.remove_pressed.connect(func(id: int): remove_player_clicked.emit(id))
	c.player_updated.connect(func(p: PlayerInfo): player_updated.emit(p))
	player_grid.move_child(add_player_container, -1)
	set_delete_player_enabled(true)
	add_player_container.visible = _player_info_containers.size() < _max_player_count

func remove_player(id: int):
	var index = _player_info_containers.find_custom(func(c: PlayerInfoContainer): return c.get_player_info().id == id)
	if index < 0:
		Log.error("[MenuUi] counldn't find player with id %s, not removing" % [id])
		return
	var container = _player_info_containers[index]
	container.queue_free()
	_player_info_containers.remove_at(index)
	if _player_info_containers.size() <= _min_player_count:
		set_delete_player_enabled(false)
	add_player_container.show()

func set_delete_player_enabled(enabled: bool):
	for c in _player_info_containers:
		c.set_delete_enabled(enabled)

#func get_edited_players() -> Array[PlayerInfo]:
	#var edited: Array[PlayerInfo] = []
	#for c in _player_info_containers:
		#edited.append(c.get_player_info())
	#return edited

func add_config_option(config: ConfigValue, on_value_changed: Callable):
	var config_option = (CONFIG_OPTION.instantiate() as ConfigOption).with_values(config, on_value_changed)
	option_container.add_child(config_option)
	
func configure_round_option(config: IntConfigValue, on_value_changed: Callable):
	fixed_rounds_container.configure(config, on_value_changed)

func display_errors(errors: Array[String]):
	alert.display_message(errors.reduce(func(msg, error): return "%s\n\n%s" % [msg, error]))

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _toggle_round_mode():
	var new_mode: Enums.RoundMode
	match _round_mode:
		Enums.RoundMode.FIXED_ROUNDS:
			new_mode = Enums.RoundMode.FIXED_POINTS
		Enums.RoundMode.FIXED_POINTS:
			new_mode = Enums.RoundMode.FIXED_ROUNDS
	_update_round_mode(new_mode)
	round_mode_changed.emit(new_mode)
	
func _update_round_mode(mode: Enums.RoundMode):
	_round_mode = mode
	match _round_mode:
		Enums.RoundMode.FIXED_ROUNDS:
			fixed_rounds_container.show()
			fixed_rounds_label.add_theme_color_override("font_color", Color.BLACK)
			fixed_points_container.hide()
			fixed_points_label.add_theme_color_override("font_color", _disabled_color)
		Enums.RoundMode.FIXED_POINTS:
			fixed_rounds_container.hide()
			fixed_rounds_label.add_theme_color_override("font_color", _disabled_color)
			fixed_points_container.show()
			fixed_points_label.add_theme_color_override("font_color", Color.BLACK)

func debug(msg: String):
	Log.debug("[Ui] %s" % msg)
