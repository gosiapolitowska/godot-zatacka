extends VBoxContainer

@onready var label = $PlayerNameLabel
@onready var color_picker = $GridContainer/ColorPickerButton
@onready var name_input = $GridContainer/NameEdit
@onready var binding_selector = %BindingSelector

var player_info: PlayerInfo

func _ready() -> void:
	color_picker.color = player_info.color
	name_input.text = player_info.name
	binding_selector.select(player_info.binding_index)
	
	update()
	name_input.text_changed.connect(on_name_changed)
	color_picker.color_changed.connect(on_color_changed)
	binding_selector.item_selected.connect(on_keys_changed)

func on_name_changed(player_name: String):
	player_info.name = player_name
	update()

func on_color_changed(color: Color):
	player_info.color = color
	update()

func on_keys_changed(index: int):
	player_info.binding_index = index

func update():
	label.text = player_info.name
	label.color = player_info.color
