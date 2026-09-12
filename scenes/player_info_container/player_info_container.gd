class_name PlayerInfoContainer extends Control

signal remove_pressed(id: int)
signal player_updated(player: PlayerInfo)

@onready var color_picker: ColorPickerButton = %ColorPickerButton
@onready var name_input: LineEdit = %NameEdit
@onready var binding_selector: BindingSelector = %BindingSelector
@onready var remove_button: Button = %RemovePlayerButton

var _player_info: PlayerInfo
var _bindings: Array[Array]

func with_values(player_info: PlayerInfo, bindings: Array[Array]) -> PlayerInfoContainer:
	_player_info = player_info.copy()
	_bindings = bindings
	return self

func set_delete_enabled(enabled: bool):
	remove_button.visible = enabled

func get_player_info() -> PlayerInfo:
	return _player_info

func _ready() -> void:
	color_picker.color = _player_info.color
	name_input.text = _player_info.name
	binding_selector.update(_bindings)
	binding_selector.select(_player_info.binding_index)
	
	_update_color()
	name_input.text_changed.connect(_on_name_changed)
	color_picker.color_changed.connect(_on_color_changed)
	binding_selector.item_selected.connect(_on_keys_changed)
	remove_button.pressed.connect(func(): remove_pressed.emit(_player_info.id))

func _on_name_changed(player_name: String):
	_player_info.name = player_name
	player_updated.emit(_player_info)

func _on_color_changed(color: Color):
	_player_info.color = color
	_update_color()
	player_updated.emit(_player_info)

func _on_keys_changed(index: int):
	_player_info.binding_index = index
	_player_info.actions = _bindings[index]
	player_updated.emit(_player_info)

func _update_color():
	name_input.add_theme_color_override("font_color", _player_info.color)
