extends CanvasLayer

func _ready() -> void:
	if Globals.debug_mode:
		add_child(DebugNode.new())
