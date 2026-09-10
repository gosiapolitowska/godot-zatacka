class_name GameEndUi extends Control

const RANKING_ITEM = preload("res://scenes/game_end_screen/player_ranking_item.tscn")

@onready var ranking_container = %RankingContainer
@onready var replay_button: Button = %ReplayButton
@onready var menu_button: Button = %MenuButton
@onready var ok_button: Button = %CloseButton

func _ready() -> void:
	ok_button.pressed.connect(func(): hide())

func update(players: Array[Player], places: Dictionary[int, String]):
	for player in players:
		var item = (RANKING_ITEM.instantiate() as PlayerRankingItem).with_values(player, places)
		ranking_container.add_child(item)

func clear():
	for child in ranking_container.get_children():
		child.queue_free()
