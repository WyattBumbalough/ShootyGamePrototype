extends EnemyState

@export var jump_state: EnemyState

var recalc_frames: int = 0
var next_pos: Vector3


func enter(_previous_state: State):
	move_speed = Char.move_speed

func handle_physics(delta) -> State:
	#Char.handle_movement(move_speed, delta)
	#Char.look_at(Char.player.global_position)
	Char.nav_agent.target_position = Char.navpoint.global_position
	
	if recalc_frames >= recalc_frames:
		next_pos = Char.nav_agent.get_next_path_position()
		recalc_frames = 0
	else:
		recalc_frames += 1
	
	
	var current_pos = Char.global_position
	var dir = current_pos.direction_to(next_pos)
	
	if dir:
		Char.velocity.x = dir.x * move_speed
		Char.velocity.z = dir.z * move_speed
	
	
	if Char.nav_agent.is_navigation_finished():
		return attack_state
	
	
	return null




#func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	##Char.velocity = Vector3.ZERO
	#state_machine.change_state(jump_state)
	
