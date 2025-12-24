extends CharacterBody3D
class_name Enemy

#@export var health: float
@export var move_speed: float = 4.5
@export var type: Global.ENEMY_TYPES

@export_category("Nodes")
@export var state_machine: StateMachine
@export var animations: AnimationPlayer
@export var nav_agent: NavigationAgent3D
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent
@export var detection_component: DetectionComponent


var path_offset: Vector3 = Vector3.ZERO
var navpoint: NavPoint

var has_target: bool = false
var player: Player

var gravity_enabled: bool = true

var dead: bool = false

func _ready():
	setup.call_deferred()
	state_machine.initialize(self)
	
	health_component.health_reached_zero.connect(die) # Call die() when health reaches zero.
	nav_agent.link_reached.connect(jump) # Jump when a nav link is pathed to.


func setup():
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("Player")


func check_for_player():
	for i in detection_component.get_overlapping_bodies():
		if i.is_in_group("Player"):
			return true
			
	return false


func _physics_process(delta: float) -> void:
	#$Label3D.text = state_machine.current_state.name
	state_machine.handle_physics(delta)	
	
	if not is_on_floor() and gravity_enabled:
		velocity.y -= 9.5 * delta
	
	move_and_slide()


func _process(delta: float) -> void:
	state_machine.handle_process(delta)


func die():
	if dead:
		return
		
	dead = true
	GameManager.enemy_killed.emit()
	if navpoint:
		navpoint.release()
	queue_free()
	

func jump(_data: Dictionary):
	if is_on_floor():
		velocity = Vector3(velocity.x, 1.5 * 5, velocity.z)
