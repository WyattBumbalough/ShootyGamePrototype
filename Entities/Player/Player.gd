extends CharacterBody3D
class_name Player

# --References--
@onready var player_state_machine: StateMachine = %PlayerStateMachine
@onready var head: Node3D = $Head
@onready var eyes: Camera3D = $Head/Eyes


#--References End--

#--Variables--
var lock_mouse: bool
var mouse_sens = 0.005
var can_move: bool = true
#--Variables end--

func _ready() -> void:
		Global.CurrentPlayer = self
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player_state_machine.initialize(self)
		
		head.rotation.y = rotation.y
		rotation.y = 0

func _unhandled_input(event: InputEvent) -> void:
		player_state_machine.handle_input(event)
		
		if event is InputEventMouseMotion and lock_mouse != true:
			head.rotate_y(-event.relative.x * mouse_sens)
			eyes.rotate_x(-event.relative.y * mouse_sens)
			
		eyes.rotation.x = clamp(eyes.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	#Display the current state.
		$CurrentState.text = player_state_machine.current_state.name
		player_state_machine.handle_physics(delta)
	# Gravity
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()

func handle_movement(speed: float, accel: float, friction: float):
	if can_move == false:
		return
# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
# Lock player movement on can_move = false
	if is_on_floor():
	# Ground Movement
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, accel)
			velocity.z = lerp(velocity.z, direction.z * speed, accel)
		# Slow player while on ground
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.z = lerp(velocity.z, 0.0, friction)
	# Air movement
	else: 
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, accel)
			velocity.z = lerp(velocity.z, direction.z * speed, accel)
