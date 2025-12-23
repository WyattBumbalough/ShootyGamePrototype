extends PlayerState

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
	
	if Char.velocity.y == 0.0 and Char.is_on_floor():
		# If not holding a direction, return to idle. 
		# Otherwise switch back to moving.
		if Input.get_vector("left","right","up","down") == Vector2.ZERO:
			return idle_state
		else:
			return moving_state 
	
	if jump_state.can_double_jump:
		if Input.is_action_just_pressed("jump") and Char.double_jump == true:
			return jump_state
	
	return null


func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("jump"):
		if can_jump and coyote <= 15.0:
			return jump_state
	return null
