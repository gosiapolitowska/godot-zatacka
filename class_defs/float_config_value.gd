class_name FloatConfigValue extends ConfigValue

func _init(name: String, min_value: float, max_value: float, value: float, step: float = 1) -> void:
	_name = name
	_value = value
	_max_value = max_value
	_min_value = min_value
	_step = step

func set_value(value: Variant):
	if value is not float:
		Log.error("Invalid value %s for config %s. Only float is accepted" % [value, _name])
		return
	_value = value
