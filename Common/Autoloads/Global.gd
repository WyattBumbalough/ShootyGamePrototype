extends Node

enum ENEMY_TYPES{ LIGHT, MEDIUM, HEAVY }
enum WAVE_DIFF{EASY, MEDIUM, HARD}

var CurrentPlayer: Player
var PlayerStateMachine: StateMachine
var wave_manager: WaveManager

var rng: RandomNumberGenerator
