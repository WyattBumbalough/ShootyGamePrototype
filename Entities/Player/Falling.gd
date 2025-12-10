extends State


func handle_physics(delta) -> State:
		Char.handle_movement(move_speed, accel, friction)
	
		if Char.velocity.y <= 0: #Is the character accelerating upwards?
			if Char.is_on_floor(): # Are they on the floor?
				if Input.get_vector("left", "right", "up", "down") == Vector2.ZERO: #Are they not pressing any inputs?
					return idle_state
				else:
					return moving_state
			else:
				return null
		else:
			return null
