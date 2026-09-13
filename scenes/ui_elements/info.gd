class_name Info extends Control

@onready var icon: Control = %InfoIcon
@onready var label: Label = %InfoLabel
@onready var panel: Control = %InfoControl

@export var txt: String = "":
	set(value):
		if label:
			label.text = value

var display := false

func _ready() -> void:
	icon.mouse_entered.connect(_display_info)
	icon.mouse_exited.connect(_hide_info)
	label.text = txt

func _display_info():
	if display:
		return
	display = true
	panel.position = icon.position + Vector2(icon.size.x, -panel.size.y) * 1.1
	panel.show()

func _hide_info():
	Log.debug("icon size: %s" % icon.size)
	if not Rect2(Vector2(), icon.size).has_point(get_global_mouse_position()):
		display = false
		panel.hide()
