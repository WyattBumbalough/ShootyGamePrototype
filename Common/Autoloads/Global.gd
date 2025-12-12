extends Node

enum ENEMY_TYPES{ LIGHT, MEDIUM, HEAVY }

var CurrentPlayer: Player
var PlayerStateMachine: StateMachine
var wave_manager: WaveManager

var rng: RandomNumberGenerator
