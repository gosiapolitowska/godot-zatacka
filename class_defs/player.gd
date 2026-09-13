class_name Player extends RefCounted

var info: PlayerInfo
var alive := true
var score := 0
var msec_lived := 0
var max_msec_lived := 0
var place := 0

func _init(info: PlayerInfo) -> void:
	self.info = info

func revive():
	alive = true
	msec_lived = 0

func add_score(points: int = 1):
	score += points

func kill(lived: int):
	alive = false
	msec_lived = lived
	if msec_lived > max_msec_lived:
		max_msec_lived = msec_lived

func copy() -> Player:
	var p = Player.new(info)
	p.alive = alive
	p.score = score
	p.msec_lived = msec_lived
	p.max_msec_lived = max_msec_lived
	p.place = place
	return p
