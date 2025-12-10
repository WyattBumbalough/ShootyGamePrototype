extends State

#--Export--
@export var jump_force: float
#--Export End--

func enter(_previous_state: State):
		Char.velocity.y = jump_force
		move_speed = _previous_state.move_speed

func handle_physics(_delta) -> State:
		Char.handle_movement(move_speed, accel, friction)
		
		if Char.velocity.y <= 0: # Is the player accelerating upwards?
			if Char.is_on_floor(): # Are they on the floor?
				if Input.get_vector("left", "right", "up", "down") == Vector2.ZERO: #Are they not pressing an input?
					return idle_state
				else:
					return moving_state
			else:
				return falling_state
		return null
