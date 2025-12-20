extends EnemyState
## Small Enemy Idle State


func enter(_previous_state: State):
	await get_tree().physics_frame


func handle_physics(_delta) -> State:
	var nav = Global.get_nav_point()
	if nav:
		Char.navpoint = nav
		Char.has_target = true
		return moving_state
	
	return null
