extends Area2D

@onready var spawn = %PlayerSpawn

const DOT_SCENE = preload("res://scenes/dot/dot.tscn")
const CRASH_SCENE = preload("res://scenes/temp_player_crash_area/temp_player_crash_area.tscn")

var lines: Dictionary[Color, PackedVector2Array] = {}

func _init() -> void:
	SignalBus.game_initiated.connect(on_game_initiated)
	SignalBus.game_started.connect(on_game_started)
	SignalBus.esc_pressed.connect(on_esc_pressed)
	SignalBus.player_moved.connect(on_player_moved)

func on_esc_pressed() -> void:
	for child in get_children():
		if child is Dot:
			child.stop()
	clear_board()
	queue_redraw()

func on_game_initiated():
	clear_board()
	create_players()
	queue_redraw()

func on_game_started():
	for child in get_children():
		if child is Dot:
			child.start()

func on_player_moved(from: Vector2, to: Vector2, player_color: Color):
	lines.get(player_color).append(to)
	var c = CRASH_SCENE.instantiate()
	c.from = from
	c.to = to
	add_child(c)
	queue_redraw()

func clear_board():
	lines.clear()
	for c in get_children():
		if c is CrashArea:
			c.queue_free()

func create_players():
	Log.debug("creating players")
	var count = PlayerManager.players.size()
	var random_factor = 1.0 / count / 3
	for i in range(count):
		var player = PlayerManager.players[i]
		var dot = DOT_SCENE.instantiate()
		dot.player_info = player
		spawn.progress_ratio = i * 1.0 / count + randf_range(-random_factor, random_factor)
		dot.global_position = spawn.global_position
		dot.rotation = spawn.rotation - 1
		add_child(dot)
		var line: PackedVector2Array = []
		line.append(dot.position)
		lines[player.color] = line

func _draw() -> void:
	for color in lines:
		var line = lines.get(color)
		if not line.is_empty():
			draw_polyline(line, color, Globals.line_width)
