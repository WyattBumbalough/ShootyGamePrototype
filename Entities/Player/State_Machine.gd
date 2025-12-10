extends Node
class_name StateMachine

#--Variables--
var current_state: State
var previous_state: State
#--Variables End--

#--Exports--
@export var starting_state: State
#--Exports End--

func initialize(Char: CharacterBody3D):
		Global.PlayerStateMachine = self
		for i in get_children():
			if i is State:
				i.Char = Char

		change_state(starting_state)

func change_state(new_state: State):
		if current_state != null:
			current_state.exit()

		previous_state = current_state
		current_state = new_state
		current_state.enter(previous_state)

func handle_physics(delta):
		var new_state = current_state.handle.physics(delta)
		if new_state != null:
			change_state(new_state)

func handle_input(event: InputEvent):
		var new_state = current_state.handle_input(event)
		if new_state != null:
			change_state(new_state)
