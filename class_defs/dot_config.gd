class_name DotConfig extends Resource

var speed: int
var rotation_speed: float
var player_size: int

func _init(speed: int, rotation_speed: float, player_size: int) -> void:
	self.speed = speed
	self.rotation_speed = rotation_speed
	self.player_size = player_size
