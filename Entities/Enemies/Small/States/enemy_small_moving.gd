extends EnemyState


func handle_physics(delta) -> State:
	Char.handle_movement(move_speed, delta)
	if Char.nav_agent.is_navigation_finished():
		return attack_state
		
	return null
