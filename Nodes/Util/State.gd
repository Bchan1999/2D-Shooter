extends Node
class_name State

signal Transitioned

#called when the machine transtions to this state
func Enter():
	pass
	
#called when state ends
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass

func get_state_name() -> String:
	push_error("Method get_state_name() must be defined")
	return ""
