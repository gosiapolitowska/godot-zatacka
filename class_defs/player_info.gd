class_name PlayerInfo extends RefCounted

var id: int
var color: Color
var name: String
var binding_index: int
var actions: Array

func _init(id: int, color: Color, name: String, binding_index: int, actions: Array) -> void:
	self.id = id
	self.color = color
	self.name = name
	self.binding_index = binding_index
	self.actions = actions

func copy() -> PlayerInfo:
	return PlayerInfo.new(id, color, name, binding_index, actions)

func _to_string() -> String:
	return "PlayerInfo{ %s, %s, %s }" % [id, name, binding_index]
