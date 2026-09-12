class_name ConfigManager extends Node

var _config: Dictionary[Enums.ConfigName, ConfigValue] = {
	Enums.ConfigName.PLAYER_COUNT: IntConfigValue.new("Player count", 2, 6, 4),
	Enums.ConfigName.ROUND_COUNT: IntConfigValue.new("Round count", 1, 11, 4),
	Enums.ConfigName.SPEED: IntConfigValue.new("Speed", 100, 700, 300, 100),
	Enums.ConfigName.PLAYER_SIZE: IntConfigValue.new("Player size", 4, 64, 16, 4),
	Enums.ConfigName.ROTATION_SPEED: FloatConfigValue.new("Rotation Speed", 1.5, 10.0, 7.7, 0.1)
}

var line_width: int = get_config(Enums.ConfigName.PLAYER_SIZE).get_min_value()
var action_bindings: Array[Array] = []
var round_mode := Enums.RoundMode.FIXED_ROUNDS
var max_points := 20

var default_colors: Array[Color] = [
	Color(0.949, 0.451, 0.831, 1.0),
	Color(0.0, 0.724, 0.896, 1.0),
	Color(1.0, 1.0, 0.11, 1.0),
	Color(1.0, 0.792, 0.0, 1.0),
	Color(0.687, 0.615, 0.981, 1.0),
	Color(1.0, 0.329, 0.401, 1.0)
]

var default_names: Array[String] = ["Matcha", "Onigiri", "Sakura", "Torii", "Mochi", "Matsuri"]

var nth: Dictionary[int, String] = {
	1: "1st",
	2: "2nd",
	3: "3rd",
	4: "4th",
	5: "5th",
	6: "6th",
}

func _init() -> void:
	default_names.shuffle()
	default_colors.shuffle()
	for i in range(get_config(Enums.ConfigName.PLAYER_COUNT).get_max_value()):
		action_bindings.append(["left_%s" % i, "right_%s" % i])
	action_bindings.shuffle()

func get_config(name: Enums.ConfigName) -> ConfigValue:
	return _config.get(name)

func update_config(name: Enums.ConfigName, value: Variant) -> ConfigValue:
	Log.debug("[ConfigManager] setting value %s: %s" % [name, value])
	var c = get_config(name)
	if value < c.get_min_value() or value > c.get_max_value():
		Log.error("[ConfigManager] invalid value %s for config %s" % [value, c])
	else:
		c.set_value(value)
	return c
