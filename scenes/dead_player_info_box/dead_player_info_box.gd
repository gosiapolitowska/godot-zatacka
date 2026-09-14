class_name DeadPlayerInfo extends Control

@onready var name_label = %NameLabel
@onready var lived_time: LivedTime = %LivedTime
@onready var lived_label: Label = %LivedLabel
@onready var millis_label: Label = %MillisLabel
@onready var indicator = %PointIndicator

var _player: Player
var _max_points: int

func with_values(max_points: int, player: Player) -> DeadPlayerInfo:
	_max_points = max_points
	_player = player
	return self

func _ready() -> void:
	indicator.configure(_max_points, _player.info.color)
	indicator.update_points(_player.score)
	name_label.text = _player.info.name
	name_label.color = _player.info.color
	
	var time = Globals.millis_to_string(_player.msec_lived).split(".")
	lived_label.text = time[0]
	millis_label.text = ".%s" % time[1]
	#lived_time.msec = _player.msec_lived
	#lived_time.font_size = 18
