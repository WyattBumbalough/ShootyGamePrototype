extends Node
class_name WaveManager

@export_group("Wave settings")
@export var max_spawn_amount: int = 10
#@export var wave_difficulty: Global.WAVE_DIFF
@export var spawn_delay: float = 0.25
@export var waves: Array[WaveResource] = []

@onready var rand = RandomNumberGenerator.new()
@onready var current_enemies: int = 0

var dead_enemies: int = 0
var spawn_pool: Array[EnemyResource] = []


func _ready() -> void:
	Global.wave_manager = self
	GameManager.enemy_killed.connect(_on_enemy_killed)
	load_wave()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("option"):
		start_wave()

func load_wave():
	var wave = waves.front()
	for s in range(wave.light_enemies):
		var e = EnemyResource.new()
		e.type = Global.ENEMY_TYPES.LIGHT
		spawn_pool.append(e)
	for m in range(wave.medium_enemies):
		var e = EnemyResource.new()
		e.type = Global.ENEMY_TYPES.MEDIUM
		spawn_pool.append(e)
	for h in range(wave.heavy_enemies):
		var e = EnemyResource.new()
		e.type = Global.ENEMY_TYPES.HEAVY
		spawn_pool.append(e)

#func start_next_wave():
	#if waves.is_empty():
		#print("No more waves!")
		#return
	#
	#GameManager.wave_started.emit()
	#
	#var wave: WaveResource = waves.front()
	#var spawner_count = get_child_count() - 1
	#
	#for i in range(wave.light_enemies):
		## Pick a random spawner node and spawn a light enemy.
		#var random_index = rand.randi_range(0, spawner_count)
		#var spawner: Spawner = get_child(random_index)
		#spawner.spawn_entity(Refs.enemy_small)
		#
		#current_enemies += 1
		#await get_tree().create_timer(spawn_delay).timeout
		#
	#waves.erase(wave)

func start_wave():
	spawn_pool.shuffle()
	
	var total_spawns = spawn_pool.size()
	var spawn_amount = min(total_spawns, max_spawn_amount)
	
	current_enemies = total_spawns
	
	while spawn_amount > 0:
		var e = spawn_pool.front()
		var spawner = get_random_spawner()
		spawn_enemy(e,spawner)
		spawn_amount -= 1
		spawn_pool.erase(e)
		await get_tree().create_timer(spawn_delay).timeout


func spawn_enemy(_enemy: EnemyResource, spawner: Spawner):
	if _enemy.type == Global.ENEMY_TYPES.LIGHT:
		spawner.spawn_entity(Refs.enemy_small)
	elif _enemy.type == Global.ENEMY_TYPES.MEDIUM:
		spawner.spawn_entity(Refs.enemy_medium)
	else:
		spawner.spawn_entity(Refs.enemy_heavy)


func get_random_spawner():
	var spawner_count = get_child_count() - 1
	var random_inx = rand.randi_range(0, spawner_count)
	var spawner: Spawner = get_child(random_inx)
	return spawner

func _on_enemy_killed():
	dead_enemies += 1
	current_enemies -= 1
	
	if current_enemies > 0:
		var e = spawn_pool.front()
		var s = get_random_spawner()
		spawn_enemy(e,s)
	
