class_name PlayerRankingItem extends Control

var style_box = preload("res://scenes/game_end_screen/item_style_box.tres")

var _textures: Dictionary[int, Resource] = {
	1: preload("res://assets/ranking/1st-shadow.png"),
	2: preload("res://assets/ranking/2nd-shadow-2.png"),
	3: preload("res://assets/ranking/3rd-shadow-2.png")
}

var _scale_factors: Dictionary[int, float] = {
	1: 0.25,
	2: 0.33,
	3: 0.38
}

var _shadow_colors: Dictionary[int, Color] = {
	1: Color("e9c112"),
	2: Color("939496"),
	3: Color("e2740c")
}

var _min_heights: Dictionary[int, int] = {
	1: 170,
	2: 120,
	3: 120
}

var _default_min_height := 70

var _place_config: Dictionary[int, PlaceInfo] = {}

@onready var ranking_texture: TextureRect = %RankingTextureRect
@onready var place_label: Label = %PlaceLabel
@onready var name_label: PlayerNameLabel = %PlayerNameLabel
@onready var score_label: PlayerNameLabel = %ScoreLabel
@onready var max_lived_label: PlayerNameLabel = %MaxLivedLabel
@onready var panel: Panel = %Ui

var _player: Player

func with_values(player: Player, places: Dictionary[int, String]) -> PlayerRankingItem:
	_player = player
	_populate_place_config(places)
	return self

func _ready() -> void:
	name_label.color = _player.info.color
	name_label.text = _player.info.name
	score_label.color = _player.info.color
	score_label.text = str(_player.score)
	max_lived_label.color = _player.info.color
	max_lived_label.text = Globals.millis_to_string(_player.max_msec_lived)
	var config := _place_config[_player.place]
	if _player.place > 3:
		ranking_texture.hide()
		place_label.show()
		place_label.text = config.place_txt
		custom_minimum_size.y = _default_min_height
	else:
		ranking_texture.show()
		ranking_texture.offset_transform_enabled = true
		ranking_texture.offset_transform_scale = Vector2(config.scale_factor, config.scale_factor)
		ranking_texture.texture = config.texture
		place_label.hide()
		var style = style_box.duplicate() as StyleBoxFlat
		style.shadow_size = 7
		style.shadow_color = _shadow_colors[_player.place]
		panel.add_theme_stylebox_override("panel", style)
		custom_minimum_size.y = _min_heights[_player.place]

func _populate_place_config(places: Dictionary[int, String]):
	for p: int in places.keys():
		if p <= 3:
			_place_config[p] = PlaceInfo.new(places[p], _textures[p], _scale_factors[p])
		else:
			_place_config[p] = PlaceInfo.new(places[p])

class PlaceInfo:
	var texture: Resource
	var scale_factor: float
	var place_txt: String
	
	func _init(place_txt: String, texture: Resource = null, scale_factor: float = 1.0) -> void:
		self.texture = texture
		self.scale_factor = scale_factor
		self.place_txt = place_txt
