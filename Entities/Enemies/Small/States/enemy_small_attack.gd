extends EnemyState
## Small enemy attack state.


func enter(_previous_state: State):
	Char.animations.play("attack")
	

func handle_physics(_delta) -> State:
	Char.handle_movement(move_speed, _delta)
	Char.look_at(Global.CurrentPlayer.global_position, Vector3.UP)
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		state_machine.change_state(idle_state)
