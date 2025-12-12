extends CharacterBody3D
class_name Enemy

#@export var health: float
@export var move_speed: float = 4.5
@export var type: Global.ENEMY_TYPES

@export_category("Nodes")
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent
@export var animations: AnimationPlayer
@export var nav_agent: NavigationAgent3D

func _ready():
	# Docs say to not use await in _ready, but you need to wait a frame to give
	# the navigation server time to sync. So this is how you do dat, BITCH.
	setup.call_deferred()
	
	# Delete when health reaches zero
	health_component.health_reached_zero.connect(die)


func setup():
	await get_tree().physics_frame
	nav_agent.target_position = Global.CurrentPlayer.global_position


func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	set_target_location(Global.CurrentPlayer.global_position)
	
	var current_pos: Vector3 = global_position
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	
	velocity = current_pos.direction_to(next_pos) * move_speed
	move_and_slide()


func set_target_location(new_position: Vector3):
	nav_agent.target_position = new_position


func die():
	GameManager.enemy_killed.emit()
	queue_free()
	
