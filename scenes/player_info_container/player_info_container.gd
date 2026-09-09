class_name PlayerInfoContainer extends Control

@onready var color_picker: ColorPickerButton = %ColorPickerButton
@onready var name_input: LineEdit = %NameEdit
@onready var binding_selector: BindingSelector = %BindingSelector

# <debug>
@export var binding_index: int
@export var c: Color
# DEBUG: remove default values
var _player_info: PlayerInfo = PlayerInfo.new(randi(), c, "Blah", binding_index, [["l1", "r1"]])
var _bindings: Array[Array] = [["left_1", "right_1"], ["left_2", "right_2"], ["left_3", "right_3"]]
# </debug>

func with_values(player_info: PlayerInfo, bindings: Array[Array]) -> PlayerInfoContainer:
	_player_info = player_info.copy()
	_bindings = bindings
	return self

func get_player_info() -> PlayerInfo:
	return _player_info

func _ready() -> void:
	color_picker.color = _player_info.color
	name_input.text = _player_info.name
	binding_selector.update(_bindings)
	binding_selector.select(_player_info.binding_index)
	
	_update()
	name_input.text_changed.connect(_on_name_changed)
	color_picker.color_changed.connect(_on_color_changed)
	binding_selector.item_selected.connect(_on_keys_changed)

func _on_name_changed(player_name: String):
	_player_info.name = player_name
	_update()

func _on_color_changed(color: Color):
	_player_info.color = color
	_update()

func _on_keys_changed(index: int):
	_player_info.binding_index = index
	_player_info.actions = _bindings[index]

func _update():
	name_input.add_theme_color_override("font_color", _player_info.color)
