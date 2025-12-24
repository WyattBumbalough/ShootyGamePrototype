extends EnemyState
## Small enemy attack state.


func enter(_previous_state: State):
	Char.velocity = Vector3.ZERO
	Char.look_at(Global.CurrentPlayer.global_position, Vector3.UP)
	Char.animations.play("attack")
	

func handle_physics(_delta) -> State:
	var dir = Char.global_position.direction_to(Char.player.global_position)
	var rotation_speed = 4
	var target_rotation = dir.signed_angle_to(Vector3.MODEL_REAR, Vector3.DOWN)
	if abs(target_rotation - Char.rotation.y) > deg_to_rad(60):
		rotation_speed = 20 # Rotates faster if more than 60 deg required.
	Char.rotation.y = lerp_angle(Char.rotation.y, target_rotation, _delta * rotation_speed)
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		state_machine.change_state(moving_state)
