extends VBoxContainer

@onready var label = $TitleLabel
@onready var color_picker = $GridContainer/ColorPickerButton
@onready var name_input = $GridContainer/NameEdit
@onready var keys_option = $GridContainer/KeysOption

var player_info: PlayerInfo

func _ready() -> void:
	label.text = player_info.name
	color_picker.color = player_info.color
	name_input.text = player_info.name
	
	keys_option.clear()
	for i in range(Globals.key_combinations.size()):
		var item = Globals.key_combinations[i]
		keys_option.add_item("%s %s" % [item[0], item[1]], i)
	keys_option.select(player_info.keys_index)
	
	name_input.text_changed.connect(on_name_changed)
	color_picker.color_changed.connect(on_color_changed)
	keys_option.item_selected.connect(on_keys_changed)

func on_name_changed(player_name: String):
	player_info.name = player_name
	label.text = player_name

func on_color_changed(color: Color):
	player_info.color = color

func on_keys_changed(index: int):
	player_info.keys_index = index
