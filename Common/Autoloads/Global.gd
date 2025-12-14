extends Node

enum ENEMY_TYPES{ LIGHT, MEDIUM, HEAVY }
enum WAVE_DIFF{EASY, MEDIUM, HARD}

var CurrentPlayer: Player
var PlayerStateMachine: StateMachine
var wave_manager: WaveManager

var rng: RandomNumberGenerator


func get_nav_point():
	var nav_points = CurrentPlayer.get_nav_points()
	var index = nav_points.size() - 1
	var point = nav_points.get(randi_range(0, index))
	return point.global_position
