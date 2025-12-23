extends CharacterBody3D

const SPEED = 5.0
const JUMP_V = 4.5

@export var gravity_enabled: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var recalc_timer: Timer = $RecalcTimer

const frames_between_recalc: int = 35
var frames_since_recalc: int = 0
var next_target: Vector3

func _ready() -> void:
	setup()
	recalc_timer.timeout.connect(func(): nav_agent.target_position = Global.CurrentPlayer.global_position)
	nav_agent.link_reached.connect(jump)


func setup():
	await get_tree().physics_frame
	nav_agent.target_position = Global.CurrentPlayer.global_position
	recalc_timer.start()


func _process(_delta: float) -> void:
	if frames_since_recalc >= frames_between_recalc:
		next_target = nav_agent.get_next_path_position()
		print(next_target)
		frames_since_recalc = 0
	else:
		frames_since_recalc += 1


func _physics_process(delta: float) -> void:
	if gravity_enabled:
		if not is_on_floor():
			velocity.y -= 9.8 * delta
	
	var dir = global_position.direction_to(next_target)
	if dir:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	
	move_and_slide()
	

func jump(data: Dictionary):
	recalc_timer.stop()
	if is_on_floor():
		velocity = Vector3(velocity.x, 1.5 * JUMP_V, velocity.z)
	
	await get_tree().create_timer(1).timeout
	recalc_timer.start()
