class_name ActivePlayerInfo extends Control

@onready var name_label = %NameLabel
@onready var rect = %ActionsRect
@onready var indicator = %PointIndicator

var _texture_generator = TextureGenerator.new()
var _player: Player
var _max_points: int

func with_values(max_points: int, player: Player) -> ActivePlayerInfo:
	_max_points = max_points
	_player = player
	return self

func _ready() -> void:
	indicator.configure(_max_points, _player.info.color)
	indicator.update_points(_player.score)
	name_label.text = _player.info.name
	name_label.color = _player.info.color
	rect.texture = _texture_generator.generate(_player.info.actions[0], _player.info.actions[1], 40)
