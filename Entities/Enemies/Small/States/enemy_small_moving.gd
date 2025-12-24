extends EnemyState

@export var nav_agent: NavigationAgent3D
## Amount of frames before navagent will refresh it's target_position. ## Higher numbers are better for performace when many instances are in the scene at once.
@export var nav_delay: float = 15 
var time: float = 0
var navpoint: NavPoint # Ref to a navpoint on the player.
var nav_offset: Vector3 # Offsets target position to add variation to paths.

# This stuff is for adding a delay on the navagent calculating the next path position.
# Setting it every frame is very expensive, esp w/ many instances.
var frames_between_recalc: int = 20
var frames_since_recalc: int = 0
var next_target: Vector3
# --------------------------------------------------------------------------------/


func enter(_previous_state: State):
	move_speed += randf_range(0, 1.75)
	navpoint = Global.get_nav_point()
	nav_offset = Vector3(randf_range(0.5, 1.0), 0 , randf_range(0.5, 1.0))
	set_target_position()


func handle_process(_delta) -> State:
	# Don't calculate path postions while the enemy is jumping.
	if not Char.is_on_floor():
		return
	
	if frames_since_recalc >= frames_between_recalc:
		next_target = nav_agent.get_next_path_position()
		frames_since_recalc = 0
	else:
		frames_since_recalc += 1
	
	return null


func handle_physics(_delta) -> State:
	if time >= nav_delay:
		set_target_position()
		if Char.check_for_player():
			return attack_state
	else:
		time += 1
	
	var dir = Char.global_position.direction_to(next_target)
	if dir:
		var rotation_speed = 4
		var target_rotation = dir.signed_angle_to(Vector3.MODEL_REAR, Vector3.DOWN)
		if abs(target_rotation - Char.rotation.y) > deg_to_rad(60):
			rotation_speed = 20 # Rotates faster if more than 60 deg required.
		Char.rotation.y = lerp_angle(Char.rotation.y, target_rotation, _delta * rotation_speed)
			
		Char.velocity.x = dir.x * move_speed
		Char.velocity.z = dir.z * move_speed
	
	#if nav_agent.is_navigation_finished():
		#Char.velocity = Vector3.ZERO
		#return attack_state
	
	
	return null


func set_target_position():
	nav_agent.target_position = navpoint.global_position + nav_offset
