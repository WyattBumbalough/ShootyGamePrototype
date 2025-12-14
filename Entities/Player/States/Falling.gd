extends State

var can_jump: bool = true
var coyote: float = 0.0

func enter(_previous_state: State):
	if _previous_state == jump_state:
		can_jump = false

func exit():
	coyote = 0.0
	can_jump = true

func handle_physics(_delta) -> State:
	Char.handle_movement(move_speed, accel, friction)
	coyote += 1
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

func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("jump"):
		if can_jump and coyote <= 15.0:
			return jump_state
	return null
