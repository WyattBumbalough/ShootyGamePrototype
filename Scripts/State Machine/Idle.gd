extends State

func handle_physics(delta) -> State:
		Char.handle_movement(move_speed, accel, friction)
	# Fall is not accelerating upward
		if Char.velocity.y <= 0 and !Char.is_on_floor():
			return falling_state
		return

func handle_input(event: InputEvent) -> State:
		if Input.is_action_just_pressed("jump"):
			return jump_state
		if Input.get_vector("left", "right", "up", "down"):
			return moving_state
		return null
