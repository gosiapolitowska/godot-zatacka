class_name DotConfig extends Resource

var speed: int
var rotation_radius: int
var player_size: int

func _init(speed: int, rotation_radius: int, player_size: int) -> void:
	self.speed = speed
	self.rotation_radius = rotation_radius
	self.player_size = player_size
