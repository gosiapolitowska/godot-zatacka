@abstract
class_name ConfigValue extends RefCounted

var _name: String
var _value: Variant
var _max_value: Variant
var _min_value: Variant
var _step: Variant
var _info: String

func get_name() -> String:
	return _name

func get_value() -> Variant:
	return _value

@abstract
func set_value(value: Variant)

func get_max_value() -> Variant:
	return _max_value

func get_min_value() -> Variant:
	return _min_value

func get_step() -> Variant:
	return _step

func get_info() -> String:
	return _info

func _to_string() -> String:
	return "ConfigValue { %s, [%s, %s], %s, step: %s }" % [_name, _min_value, _max_value, _value, _step]
