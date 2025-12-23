extends EnemyState

var can_move: bool = false

func enter(_previous_state: State):
	#Char.velocity =  Vector3(Char.velocity.x, 300, Char.velocity.z)
	var v = Char.velocity
	v.y += 2500
	Char.velocity = v
	
	#Char.gravity_enabled = false
	#Char.velocity.y += 8.0
	#await get_tree().create_timer(1.5).timeout
	#Char.gravity_enabled = true

#func exit():
	#can_move = false

#func handle_physics(_delta) -> State:
	#Char.handle_movement(move_speed, _delta)
	#return null
