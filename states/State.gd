extends Node

# basically an interface for states
class_name State

signal Transitioned

# called on the transition to this state
func Enter():
	pass

# called on the transition away 
# from this state
func Exit():
	pass

# equivalent to _process controlled 
# by the state machine
func Update(_delta: float):
	pass
	
# equivalent to _physics_process controlled 
# by the state machine
func Physics_Update(_delta: float):
	pass
