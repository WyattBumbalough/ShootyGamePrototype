extends EnemyState
## Small Enemy Idle State

@export var  wait_time: float = 3.5
var time : float = 0

func enter(_previous_state: State):
	pass

func exit():
	time = 0

func handle_process(_delta) -> State:
	if time >= wait_time:
		return moving_state
	else:
		time += 1 * _delta
	
	return null
