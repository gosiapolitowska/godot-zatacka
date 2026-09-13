class_name PlayArea extends StaticBody2D

@onready var spawn: PathFollow2D = %PlayerSpawn

signal player_collided(player: PlayerInfo)

const DOT_SCENE = preload("res://scenes/dot/dotto.tscn")
const CRASH_SCENE = preload("res://scenes/temp_player_crash_area/temp_player_crash_area.tscn")

var _players: Dictionary[int, PlayerInfo]
var _lines: Dictionary[int, PackedVector2Array] = {}
var _line_width: int
var _dot_config: DotConfig
var _delay: float

func initialize(line_width: int, area_position: Vector2, area_size: Vector2):
	_line_width = line_width
	Log.debug("[PlayArea] initializing with position %s and size %s" % [area_position, area_size])
	var area_end = area_position + area_size
	_add_wall(area_position, Vector2(area_end.x, area_position.y))
	_add_wall(area_position, Vector2(area_position.x, area_end.y))
	_add_wall(Vector2(area_end.x, area_position.y), area_end)
	_add_wall(Vector2(area_position.x, area_end.y), area_end)

func clear() -> void:
	for child in get_children():
		if child is Dotto:
			child.stop()
	_players.clear()
	_clear_board()
	queue_redraw()

func initiate(players: Array[PlayerInfo], dot_config: DotConfig, delay: float):
	_dot_config = dot_config
	_delay = delay
	_clear_board()
	for player in players:
		_players[player.id] = player
	_create_players(players)
	queue_redraw()

func start_players():
	for child in get_children():
		if child is Dotto:
			child.start()

func _add_wall(from: Vector2, to: Vector2):
	var shape = SegmentShape2D.new()
	shape.a = to_local(from)
	shape.b = to_local(to)
	Log.debug("[PlayArea] bulding wall from %s to %s" % [shape.a, shape.b])
	
	var c = CollisionShape2D.new()
	c.shape = shape
	add_child(c)

func _on_player_moved(from: Vector2, to: Vector2, player: PlayerInfo):
	_lines.get(player.id).append(to)
	var c = (CRASH_SCENE.instantiate() as CrashArea).with_values(from, to, _delay)
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
		var dot := (DOT_SCENE.instantiate() as Dotto).with_values(_dot_config, player)
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
