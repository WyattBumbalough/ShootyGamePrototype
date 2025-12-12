extends Node

signal wave_started
signal wave_ended
signal enemy_spawned # Emitted when a spawner spawns an enemy.
signal enemy_killed # Emitted when an enemy's die function is called.

func _ready() -> void:
	wave_started.connect(func(): print("Wave Started!"))
	wave_ended.connect(func(): print("Wave ended!"))
	enemy_spawned.connect(func(): print("Enemy Spawned!"))
	enemy_killed.connect(func(): print("Enemy killed!"))
