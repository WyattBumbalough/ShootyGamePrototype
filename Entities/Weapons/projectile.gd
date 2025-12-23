extends CharacterBody3D
class_name Projectile

@onready var hitbox: Area3D = $Hitbox


# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	velocity.x = 50
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
