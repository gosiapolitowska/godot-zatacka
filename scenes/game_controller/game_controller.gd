class_name GameController extends Control

signal player_died(player: PlayerInfo)

@export var play_area: PlayArea
@export var player_manager: PlayerManager
@export var config_manager: ConfigManager

func _ready() -> void:
	play_area.initialize(config_manager.line_width, position, size)
	play_area.player_collided.connect(func(p): player_died.emit(p))

func clear():
	play_area.clear()

func initiate():
	var dot_config = DotConfig.new(_config_value(Enums.ConfigName.SPEED), _config_value(Enums.ConfigName.ROTATION_RADIUS), _config_value(Enums.ConfigName.PLAYER_SIZE))
	play_area.clear()
	play_area.initiate(player_manager.players, dot_config, float(dot_config.player_size) / 2.0 / float(dot_config.speed))

func start():
	play_area.start_players()

func _config_value(config_name: Enums.ConfigName) -> Variant:
	return config_manager.get_config(config_name).get_value()
