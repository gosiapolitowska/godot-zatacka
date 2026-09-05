extends Control

const PLAYER_INFO_CONTAINER = preload("res://scenes/player_info_container/player_info_container.tscn")

@onready var start_button = %StartButton
@onready var player_grid = %PlayerConfigGrid
@onready var count_panel = %PlayerCountPanel
@onready var alert = %Alert
@onready var speed_value_label = %SpeedValueLabel
@onready var speed_slider = %SpeedSlider
@onready var rotation_value_label = %RotationValueLabel
@onready var rotation_slider = %RotationSlider
@onready var size_value_label = %SizeValueLabel
@onready var size_slider = %SizeSlider

var player_info_panels: Array[Node] = []

func _init() -> void:
	SignalBus.players_modified.connect(on_players_modified)
	SignalBus.esc_pressed.connect(on_esc_pressed)

func on_esc_pressed() -> void:
	show()

func _ready() -> void:
	player_grid.columns = Globals.max_players
	for i in range(Globals.min_players, Globals.max_players + 1):
		add_button(i)
	
	speed_value_label.text = str(Globals.speed)
	speed_slider.min_value = Globals.speed_min
	speed_slider.max_value = Globals.speed_max
	speed_slider.value = Globals.speed
	speed_slider.value_changed.connect(on_speed_changed)
	
	rotation_value_label.text = str(Globals.rotation_speed)
	rotation_slider.min_value = Globals.rotation_speed_min
	rotation_slider.max_value = Globals.rotation_speed_max
	rotation_slider.value = Globals.rotation_speed
	rotation_slider.value_changed.connect(on_rotation_changed)
	
	size_value_label.text = str(Globals.player_size)
	size_slider.min_value = Globals.player_size_min
	size_slider.max_value = Globals.player_size_max
	size_slider.value = Globals.player_size
	size_slider.value_changed.connect(on_size_changed)
	
	SignalBus.player_count_selected.emit(Globals.default_player_count)

func on_speed_changed(speed: float):
	Globals.speed = int(speed)
	speed_value_label.text = str(Globals.speed)

func on_rotation_changed(r: float):
	Globals.rotation_speed = r
	rotation_value_label.text = str(Globals.rotation_speed)

func on_size_changed(size: float):
	Globals.player_size = int(size)
	size_value_label.text = str(Globals.player_size)

func add_button(n: int) -> void:
	var button = Button.new()
	button.text = str(n)
	button.custom_minimum_size = Vector2(100, 0)
	button.pressed.connect(on_player_count_selected.bind(n))
	count_panel.add_child(button)

func on_player_count_selected(count: int):
	SignalBus.player_count_selected.emit(count)

func on_players_modified(type: Globals.PlayerModifiedType):
	if type != Globals.PlayerModifiedType.CREATED:
		return
	start_button.disabled = false
	for panel in player_info_panels:
		panel.queue_free()
	player_info_panels.clear()
	for player in PlayerManager.players:
		var info_panel = PLAYER_INFO_CONTAINER.instantiate()
		info_panel.player_info = player
		player_info_panels.append(info_panel)
		player_grid.add_child(info_panel)

func _on_start_button_pressed() -> void:
	var players = PlayerManager.players
	var errors = []
	
	if is_not_unique(players, func(player: PlayerInfo): return player.binding_index):
		errors.append("All players must have unique key bindings")
	if is_not_unique(players, func(player: PlayerInfo): return player.color):
		errors.append("All players must have unique colors")
	
	if errors.is_empty():
		hide()
		SignalBus.game_initiated.emit()
		SignalBus.players_modified.emit(Globals.PlayerModifiedType.UPDATED)
	else:
		alert.display_message(errors.reduce(func(msg, error): return "%s\n\n%s" % [msg, error]))

func is_not_unique(players: Array, field_extractor: Callable) -> bool:
	var dict = {}
	players.map(func(item): dict[field_extractor.call(item)] = 1)
	return dict.size() != players.size()

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
