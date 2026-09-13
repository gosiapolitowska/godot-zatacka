class_name ConfigOption extends Control

@onready var label = %Label as Label
@onready var value_label = %ValueLabel as Label
@onready var slider = %Slider as Slider
@onready var info: Info = %Info

var _config: ConfigValue
var _on_value_changed: Callable

func with_values(config: ConfigValue, on_value_changed: Callable) -> ConfigOption:
	Log.debug("[ConfigOption] got value: %s" % config)
	_config = config
	_on_value_changed = on_value_changed
	return self

func configure(config: ConfigValue, on_value_changed: Callable):
	_config = config
	_on_value_changed = on_value_changed
	_update()

func _ready() -> void:
	_update()
	
func _update():
	if not _config:
		return
	label.text = _config.get_name()
	value_label.text = str(_value(_config.get_value()))
	slider.max_value = _config.get_max_value()
	slider.min_value = _config.get_min_value()
	slider.value = _config.get_value()
	slider.step = _config.get_step()
	slider.value_changed.connect(_on_value_changed_internal)
	
	if not _config.get_info().is_empty():
		info.show()
		info.txt = _config.get_info()

func _on_value_changed_internal(value):
	value_label.text = str(_value(value))
	_on_value_changed.call(_value(value))

func _value(v: Variant) -> Variant:
	match _config:
		var i when i is IntConfigValue:
			return int(v)
		var f when f is FloatConfigValue:
			return float(v)
		_:
			return v
