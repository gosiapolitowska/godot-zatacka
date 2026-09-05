extends Control

@onready var name_label = %NameLabel
@onready var place_label = %PlaceLabel
@onready var score_label = %ScoreLabel

var player_info: PlayerInfo

func _ready() -> void:
	name_label.text = player_info.name
	name_label.color = player_info.color
	place_label.text = Globals.nth.get(player_info.place)
	score_label.text = Globals.seconds_to_string(player_info.sec_lived)
