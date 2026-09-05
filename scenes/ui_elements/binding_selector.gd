extends OptionButton

var texture_generator = TextureGenerator.new()

func _ready() -> void:
	clear()
	for i in range(Globals.max_players):
		var action_pair = Globals.action_bindings[i]
		var texture = texture_generator.generate(action_pair[0], action_pair[1], 40)
		add_icon_item(texture, "", i)
