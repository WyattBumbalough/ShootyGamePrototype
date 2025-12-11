extends Node
class_name State

#--Variables--
var Char: Player
#--Varibles End--

#--Exports--
#@export_category("States")
@export var idle_state: State
@export var jump_state: State
@export var falling_state: State
@export var moving_state: State
@export_category("Movement Tweaking") #Exports movement variables
@export var move_speed: float = 7
@export var accel: float = 0.05
@export var friction: float = 0.1
#--Exports End--

func enter(_previous_state: State):
		pass

func exit():
		pass
		
func handle_physics(_delta) -> State:
		return null

func handle_input(_event: InputEvent) -> State:
	return null
