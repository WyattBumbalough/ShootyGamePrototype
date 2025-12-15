extends CharacterBody3D
class_name Enemy

#@export var health: float
@export var move_speed: float = 4.5
@export var type: Global.ENEMY_TYPES

@export_category("Nodes")
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent
@export var mesh: MeshInstance3D
@export var animations: AnimationPlayer
@export var nav_agent: NavigationAgent3D

var path_offset: Vector3 = Vector3.ZERO
var navpoint: NavPoint
var has_target: bool = false

var active: bool = true
var dead: bool = false

func _ready():
	# Docs say to not use await in _ready, but you need to wait a frame to give
	# the navigation server time to sync. So this is how you do dat, BITCH.
	setup.call_deferred()
	# Call die() when health reaches zero.
	health_component.health_reached_zero.connect(die)
	


func setup():
	await get_tree().physics_frame
	
	move_speed += randf_range(0.5, 2.0) # Add variation to move speed so they won't clump up.
	path_offset += Vector3(randf_range(0.5,2.5), 0.0, randf_range(0.5,2.5)) # Same for target postition.
	
	set_target_location(Global.CurrentPlayer.global_position + path_offset)
	navpoint = Global.get_nav_point()
	if navpoint:
		set_target_location(navpoint.global_position)
	

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	if navpoint == null:
		return
	set_target_location(navpoint.global_position)
	
	var current_pos: Vector3 = global_position
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	var dir = current_pos.direction_to(next_pos)
	
	velocity = dir * move_speed
	
	var rotation_speed = 4
	var target_rotation = dir.signed_angle_to(-Vector3.MODEL_FRONT, Vector3.DOWN)
	if abs(target_rotation - rotation.y) > deg_to_rad(60):
		rotation_speed = 20 # Rotates faster if more than 60 deg required.
	rotation.y = move_toward(rotation.y, target_rotation, _delta * rotation_speed)
	
	move_and_slide()


func set_target_location(new_position: Vector3):
	nav_agent.target_position = new_position


func die():
	if dead:
		return
		
	dead = true
	GameManager.enemy_killed.emit()
	if navpoint:
		navpoint.release()
	queue_free()
	
