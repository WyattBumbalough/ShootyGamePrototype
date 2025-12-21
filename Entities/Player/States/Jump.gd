extends PlayerState

#--Export--
@export var jump_force: float
@export var can_double_jump: bool = false
@export var double_jump_force: float = 5.0

#--Export End--

func enter(_previous_state: State):
	Char.velocity.y = jump_force
	if can_double_jump:
		Char.double_jump = true


func handle_physics(_delta) -> State:
	Char.handle_movement(move_speed, accel, friction)
	
	if Char.velocity.y < 0.0 and not Char.is_on_floor():
		return falling_state
	
	if can_double_jump:
		if Input.is_action_just_pressed("jump") and not Char.is_on_floor(): #and Char.double_jump and !Char.is_on_floor():
			Char.velocity.y += double_jump_force
			Char.double_jump = false
	
	return null
