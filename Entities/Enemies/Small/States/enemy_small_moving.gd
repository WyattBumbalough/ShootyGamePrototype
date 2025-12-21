extends EnemyState

@export var jump_state: EnemyState

func enter(_previous_state: State):
	move_speed = Char.move_speed

func handle_physics(delta) -> State:
	Char.handle_movement(move_speed, delta)
	Char.look_at(Char.player.global_position)
	
	if Char.nav_agent.is_navigation_finished():
		return attack_state
	
	
	return null




func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	#Char.velocity = Vector3.ZERO
	state_machine.change_state(jump_state)
	
