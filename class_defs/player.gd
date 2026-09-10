class_name Player extends RefCounted

var info: PlayerInfo
var alive := true
var score := 0
var sec_lived := 0
var max_sec_lived := 0
var place := 0

func _init(info: PlayerInfo) -> void:
	self.info = info

func revive():
	alive = true
	sec_lived = 0

func add_score(points: int = 1):
	score += points

func kill(lived: int):
	alive = false
	sec_lived = lived
	if sec_lived > max_sec_lived:
		max_sec_lived = sec_lived

func copy() -> Player:
	var p = Player.new(info)
	p.alive = alive
	p.score = score
	p.sec_lived = sec_lived
	p.max_sec_lived = max_sec_lived
	p.place = place
	return p
