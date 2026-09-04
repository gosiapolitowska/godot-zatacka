class_name PlayerInfo

var id: int
var color: Color
var name: String
var keys_index: int
var alive: bool = true
var place: int = 0
var sec_lived: int = 0

func _init(id: int, color: Color, name: String, keys_index: int) -> void:
	self.id = id
	self.color = color
	self.name = name
	self.keys_index = keys_index

func _to_string() -> String:
	return "Player{ %s, %s, %s, %s, %s }" % [id, name, keys_index, sec_lived, place]

func revive():
	alive = true
	place = 0
	sec_lived = 0

func kill(place: int, sec_lived: int):
	alive = false
	self.place = place
	self.sec_lived = sec_lived
