class_name IntConfigValue extends ConfigValue

func _init(name: String, min_value: int, max_value: int, value: int, step: int = 1) -> void:
	_name = name
	_value = value
	_max_value = max_value
	_min_value = min_value
	_step = step

func set_value(value: Variant):
	if value is not int:
		Log.error("Invalid value %s for config %s. Only int is accepted" % [value, _name])
		return
	_value = value
