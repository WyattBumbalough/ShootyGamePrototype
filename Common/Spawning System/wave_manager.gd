extends Node
class_name WaveManager

@export_group("Wave settings")
@export var max_spawn_amount: int = 10 ## Maximum amount of entities that can be spawned at the same time.
@export var spawn_delay: float = 0.25 ## Time between each entity spawn.
@export var waves: Array[WaveResource] = []

@onready var rand = RandomNumberGenerator.new()
@onready var current_enemies: int = 0

var dead_enemies: int = 0
var spawn_pool: Array[EnemyResource] = []


func _ready() -> void:
	Global.wave_manager = self
	GameManager.enemy_killed.connect(_on_enemy_killed)
	#load_wave()


func load_wave():
	# Get and remove the first wave resource from waves array.
	var wave = waves.pop_front()
	
	# Create an amount of enemy reources equal to amount of each type in the wave
	# resource, then load them into the spawn pool.
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
	
	start_wave()


func start_wave():
	spawn_pool.shuffle() # Randomize the spawn pool.
	
	var total_spawns = spawn_pool.size()
	var spawn_amount = min(total_spawns, max_spawn_amount)
	
	current_enemies = total_spawns
	
	while spawn_amount > 0:
		spawn_enemy()
		spawn_amount -= 1
		await get_tree().create_timer(spawn_delay).timeout


func spawn_enemy():
	var _enemy = spawn_pool.pop_front()
	var _spawner = get_random_spawner()
	
	if _enemy.type == Global.ENEMY_TYPES.LIGHT:
		_spawner.spawn_entity(Refs.enemy_small)
	elif _enemy.type == Global.ENEMY_TYPES.MEDIUM:
		_spawner.spawn_entity(Refs.enemy_medium)
	else:
		_spawner.spawn_entity(Refs.enemy_heavy)


func get_random_spawner():
	var spawner_count = get_child_count() - 1
	var random_inx = rand.randi_range(0, spawner_count)
	var spawner: Spawner = get_child(random_inx)
	return spawner


func _on_enemy_killed():
	dead_enemies += 1
	current_enemies -= 1
	await get_tree().create_timer(0.5).timeout
	
	if spawn_pool.size() > 0:
		spawn_enemy()
	if current_enemies == 0:
		GameManager.wave_ended.emit()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("option") and not waves.is_empty():
		load_wave()
