extends Control

@onready var name_label = %NameLabel
@onready var key_left = %KeyLeft
@onready var key_right = %KeyRight

var player_info: PlayerInfo

func _ready() -> void:
	name_label.text = player_info.name
	name_label.add_theme_color_override("font_color", player_info.color)
	key_left.action_name = "left_%s" % player_info.keys_index
	key_right.action_name = "right_%s" % player_info.keys_index
