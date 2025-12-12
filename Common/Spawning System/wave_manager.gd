extends Node
class_name WaveManager

#@export var test_spawn: PackedScene
@export var waves: Array[WaveResource] = []
@export var spawn_delay: float = 0.25

@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies: int = 0

var current_enemies: int = 0
var wave_dict: Dictionary = {
	"Light" : 0,
	"Medium" : 0,
	"Heavy" : 0
}

func _ready() -> void:
	Global.wave_manager = self
	GameManager.enemy_killed.connect(_on_enemy_killed)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("option"):
		start_next_wave()


func start_next_wave():
	if waves.is_empty():
		print("No more waves!")
		return
	
	GameManager.wave_started.emit()
	
	var wave: WaveResource = waves.front()
	var spawner_count = get_child_count() - 1

	for i in range(wave.light_enemies):
		# Pick a random spawner node.
		var random_index = rand.randi_range(0, spawner_count)
		var spawner: Spawner = get_child(random_index)
		spawner.spawn_entity(Refs.enemy_small)
		
		current_enemies += 1
		await get_tree().create_timer(spawn_delay).timeout
		
	waves.erase(wave)


func _on_enemy_killed():
	dead_enemies += 1
	current_enemies -= 1
	
