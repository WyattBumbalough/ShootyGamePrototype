extends CharacterBody3D
class_name Enemy

#@export var health: float
@export var move_speed: float = 4.5
@export var type: Global.ENEMY_TYPES

@export_category("Nodes")
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent
@export var state_machine: StateMachine
@export var animations: AnimationPlayer
@export var nav_agent: NavigationAgent3D

var path_offset: Vector3 = Vector3.ZERO
var navpoint: NavPoint

var has_target: bool = false
var player: Player

var gravity_enabled: bool = true

var dead: bool = false

func _ready():
	setup.call_deferred()
	state_machine.initialize(self)
	
	# Call die() when health reaches zero.
	health_component.health_reached_zero.connect(die)
	nav_agent.link_reached.connect(jump)
	


func setup():
	await get_tree().physics_frame
	move_speed += randf_range(0.5, 2.0) # Add variation to move speed so they won't clump up.
	
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	state_machine.handle_physics(delta)	
	$Label3D.text = state_machine.current_state.name
	

	if not is_on_floor() and gravity_enabled:
		velocity.y -= 9.5 * delta
	
	move_and_slide()


func _process(delta: float) -> void:
	state_machine.handle_process(delta)
	

func handle_movement(speed: float, delta: float):
	set_target_location(navpoint.global_position)
	
	var current_pos = global_position
	var next_pos = nav_agent.get_next_path_position()
	var dir = current_pos.direction_to(next_pos)
	
	var rotation_speed = 4
	var target_rotation = dir.signed_angle_to(Vector3.MODEL_REAR, Vector3.DOWN)
	if abs(target_rotation - rotation.y) > deg_to_rad(60):
		rotation_speed = 20 # Rotates faster if more than 60 deg required.
	
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * rotation_speed)
	
	#rotation.y = move_toward(rotation.y, target_rotation, delta * rotation_speed)
	
	velocity = dir * speed


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
	

func jump(data: Dictionary):
	if is_on_floor():
		velocity = Vector3(velocity.x, 1.5 * 5, velocity.z)
