extends Control

func _on_ok_button_pressed() -> void:
	hide()

func display_message(text: String):
	show()
	%Msg.text = text
