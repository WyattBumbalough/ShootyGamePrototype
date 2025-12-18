extends Node

signal wave_started
signal wave_ended
signal enemy_spawned # Emitted when a spawner spawns an enemy.
signal enemy_killed # Emitted when an enemy's die function is called.

var wave_manager: WaveManager

var game_started: bool = false

func _ready() -> void:
	wave_started.connect(func(): print("Wave Started!"))
	wave_ended.connect(func(): print("Wave ended!"))
	enemy_spawned.connect(func(): print("Enemy Spawned!"))
	enemy_killed.connect(func(): print("Enemy killed!"))


func start_game():
	if game_started:
		return
	wave_manager.load_wave()
	game_started = true
