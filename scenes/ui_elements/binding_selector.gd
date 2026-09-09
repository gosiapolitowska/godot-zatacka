class_name BindingSelector extends OptionButton

var texture_generator = TextureGenerator.new()

func update(bindings: Array[Array]):
	clear()
	var popup := get_popup()
	for i in range(bindings.size()):
		var action_pair := bindings[i]
		var texture := texture_generator.generate(action_pair[0], action_pair[1], 40)
		add_icon_item(texture, "", i)
		
		var index := popup.item_count - 1
		popup.set_item_as_radio_checkable(index, false)
