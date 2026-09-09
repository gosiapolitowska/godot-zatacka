class_name PlayArea extends Area2D

@onready var spawn: PathFollow2D = %PlayerSpawn

signal player_collided(player: PlayerInfo)

const DOT_SCENE = preload("res://scenes/dot/dot.tscn")
const CRASH_SCENE = preload("res://scenes/temp_player_crash_area/temp_player_crash_area.tscn")

var _players: Dictionary[int, PlayerInfo]
var _lines: Dictionary[int, PackedVector2Array] = {}
var _line_width: int
var _dot_config: DotConfig

func initialize(line_width: int):
	_line_width = line_width

func clear() -> void:
	for child in get_children():
		if child is Dot:
			child.stop()
	_players.clear()
	_clear_board()
	queue_redraw()

func initiate(players: Array[PlayerInfo], dot_config: DotConfig):
	_dot_config = dot_config
	_clear_board()
	for player in players:
		_players[player.id] = player
	_create_players(players)
	queue_redraw()

func start_players():
	for child in get_children():
		if child is Dot:
			child.start()

func _on_player_moved(from: Vector2, to: Vector2, player: PlayerInfo):
	_lines.get(player.id).append(to)
	var c = CRASH_SCENE.instantiate()
	c.from = from
	c.to = to
	add_child(c)
	queue_redraw()

func _clear_board():
	_lines.clear()
	for c in get_children():
		if c is CrashArea:
			c.queue_free()

func _create_players(players: Array[PlayerInfo]):
	Log.debug("[PlayArea] creating players")
	var count = players.size()
	var random_factor = 1.0 / count / 3
	for i in range(count):
		var player := players[i]
		var dot := (DOT_SCENE.instantiate() as Dot).with_values(_dot_config, player)
		spawn.progress_ratio = i * 1.0 / count + randf_range(-random_factor, random_factor)
		dot.global_position = spawn.global_position
		dot.rotation = spawn.rotation - 1
		dot.collided.connect(func(p): player_collided.emit(p))
		dot.moved.connect(_on_player_moved)
		add_child(dot)
		var line: PackedVector2Array = []
		line.append(dot.position)
		_lines[player.id] = line

func _draw() -> void:
	for player_id in _lines:
		var color = _players[player_id].color
		var line = _lines[player_id]
		if line.size() > 1:
			draw_polyline(line, color, _line_width)
