extends Node
class_name WaveManager

@export var test_spawn: PackedScene

func _ready() -> void:
	initialize()

func initialize():
	for i in get_children():
		if i is Spawner:
			await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
			i.spawn_entity(test_spawn)
