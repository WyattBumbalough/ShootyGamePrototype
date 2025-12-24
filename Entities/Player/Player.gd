extends CharacterBody3D
class_name Player

@export var player_state_machine: StateMachine
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent

# --References----------------------------------------------------------|

@onready var head: Node3D = $Head
@onready var eyes: Camera3D = $Head/Eyes
@onready var nav_points: Node3D = %NavPointsInner

# UI References ---------|
@onready var start_game_container: CenterContainer = %StartGameContainer
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var enemy_count_label: Label = %EnemyCountLabel

#--References End------------------------------------------------------|

#--Variables--
var lock_mouse: bool
var mouse_sens = 0.005
var can_move: bool = true
var double_jump: bool
#--Variables end--


func _ready() -> void:
	add_to_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.CurrentPlayer = self
	Global.PlayerStateMachine = player_state_machine
	
	
	player_state_machine.initialize(self)
	
	head.rotation.y = rotation.y
	rotation.y = 0


func _unhandled_input(event: InputEvent) -> void:
	player_state_machine.handle_input(event)
	
	if event is InputEventMouseMotion and lock_mouse != true:
		head.rotate_y(-event.relative.x * mouse_sens)
		eyes.rotate_x(-event.relative.y * mouse_sens)
		
	eyes.rotation.x = clamp(eyes.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if Input.is_action_just_pressed("esc"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("shoot"):
		raycast()


func _process(_delta: float) -> void:
	#enemy_count_label.text = "Enemies remaining: " + str(GameManager.wave_manager.current_enemies)
	if start_game_container.visible:
		if Input.is_action_pressed("action") and not GameManager.game_started:
			texture_progress_bar.value += 1.0
			if texture_progress_bar.value >= 100.0:
				GameManager.start_game()
				start_game_container.hide()
		elif Input.is_action_just_released("action") and not GameManager.game_started:
			texture_progress_bar.value = 0.0
	#		Do a bunch of stuff.



func _physics_process(delta: float) -> void:
	#Display the current state.
	%CurrentState.text = player_state_machine.current_state.name
	player_state_machine.handle_physics(delta)
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func handle_movement(speed: float, accel: float, friction: float):
	if can_move == false:
		return
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# Lock player movement on can_move = false
	if is_on_floor():
		# Ground Movement
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, accel)
			velocity.z = lerp(velocity.z, direction.z * speed, accel)
		# Slow player while on ground
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.z = lerp(velocity.z, 0.0, friction)
	# Air movement
	else: 
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, accel)
			velocity.z = lerp(velocity.z, direction.z * speed, accel)


func raycast():
	# Raycast should only run when this function is called, so that it isn't constantly
	# calculating collisions.
	var ray: RayCast3D = $Head/Eyes/TestRaycast
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider is HitboxComponent:
			collider.take_damage.call_deferred(55.0)


#func get_nav_points() -> Array:
	#return nav_points.get_children()


func get_available_navpoint() -> NavPoint:
	var available_points: Array
	for n: NavPoint in nav_points.get_children():
		if n.claimed == false:
			available_points.append(n)
	if available_points.is_empty():
		printerr("No more available navpoints!")
		return null
	var amount = available_points.size() - 1
	var i = randi_range(0, amount)
	var nav: NavPoint = available_points.get(i)
	
	return nav

func get_navpoint() -> NavPoint:
	var points = nav_points.get_children()
	var a = points.size() - 1
	var index = randi_range(0, a)
	var point = points.get(index)
	#return point.global_position
	if point:
		return point
	
	return null

func _on_health_component_damage_taken(amount: Variant) -> void:
	print("Ow, that hurt like a " + str(amount))
