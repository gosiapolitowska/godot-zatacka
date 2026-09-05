extends Node

enum PlayerModifiedType { CREATED, UPDATED }

var action_bindings: Array[Array] = []

var default_colors = [
	Color(0.949, 0.451, 0.831, 1.0),
	Color(0.0, 0.724, 0.896, 1.0),
	Color(1.0, 1.0, 0.11, 1.0),
	Color(1.0, 0.792, 0.0, 1.0),
	Color(0.687, 0.615, 0.981, 1.0),
	Color(1.0, 0.329, 0.401, 1.0)
]

var default_names = ["Matcha", "Onigiri", "Sakura", "Torii", "Mochi", "Matsuri"]

var max_players: int = 6
var min_players: int = 1
var default_player_count: int = 4

var nth = {
	1: "1st",
	2: "2nd",
	3: "3rd",
	4: "4th",
	5: "5th",
	6: "6th",
}

@export var speed: int = 300
@export var rotation_speed: float = 7.7
@export var player_size: int = 16

var speed_min: int = 100
var speed_max: int = 700
var rotation_speed_min: float = 1.5
var rotation_speed_max: float = 10.0
var player_size_min: int = 4
var player_size_max: int = 64

var line_width: int = player_size_min

func _init() -> void:
	default_names.shuffle()
	default_colors.shuffle()
	for i in range(max_players):
		action_bindings.append(["left_%s" % i, "right_%s" % i])
	action_bindings.shuffle()

func seconds_to_string(time_in_sec: int):
	var seconds = time_in_sec % 60
	var minutes = time_in_sec / 60

	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d" % [minutes, seconds - (60 * minutes)]
