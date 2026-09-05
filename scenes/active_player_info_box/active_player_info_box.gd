extends Control

@onready var name_label = %NameLabel
@onready var rect = %ActionsRect

var texture_generator = TextureGenerator.new()
var player_info: PlayerInfo

func _ready() -> void:
	name_label.text = player_info.name
	name_label.color = player_info.color
	var actions = Globals.action_bindings[player_info.binding_index]
	rect.texture = texture_generator.generate(actions[0], actions[1], 40)
