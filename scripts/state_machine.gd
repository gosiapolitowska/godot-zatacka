class_name StateMachine
extends Node

var transitions: Dictionary[int, Array] = {}
var state: int
var name_by_value: Dictionary[int, String] = {}

func _init(enum_class: Dictionary, initial_state: int = -1) -> void:
	state = initial_state
	for name in enum_class.keys():
		name_by_value[enum_class[name]] = name

func add_transition(to, from: Array[int]):
	transitions[to] = from

func transition_if_valid(new_state: int) -> bool:
	var from_states: Array = transitions.get(new_state, [])
	if state >= 0 and state not in from_states:
		Log.error("Transition %s -> %s is not valid" % [name_by_value[state], name_by_value[new_state]])
		return false
	state = new_state
	return true
