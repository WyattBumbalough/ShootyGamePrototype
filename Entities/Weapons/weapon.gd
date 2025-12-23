extends Node3D
class_name Weapon

@export_category("Parameters")
@export var weapon_name: String
@export var damage: float = 10.0
@export var gunshot_sound: AudioStream
@export var projectile: Projectile
var nail = preload("res://Entities/Weapons/nail.tscn")
enum shot_type {HITSCAN,PROJ}
@export var ShotType: shot_type
@export_category("Nodes")
@export var animations: AnimationPlayer
@export var audio: AudioStreamPlayer3D
var can_shoot: bool = true

func _ready() -> void:
	hide()

func equip():
	show()
	if animations:
		animations.play("equip")

func unequip():
	hide()
	

func shoot():
	if !can_shoot:
		return
	if !animations:
		return
	match ShotType:
		shot_type.HITSCAN: #Hitscan
			var space = get_world_3d().direct_space_state #Grab the current world's 3d space
			var query = PhysicsRayQueryParameters3D.create(%Eyes.global_position,%Eyes.global_position - %Eyes.global_transform.basis.z * 100) #Creates a rayquery from the camera's origin
			query.collide_with_areas = true #make so the query can collide with areas
			var collision = space.intersect_ray(query) #Setting the dictornary the query grabs to a var
			if collision != {}: #Book empty, me no want
				var target = collision.collider # Grab the object is collided with
				if target is HitboxComponent:
					target.take_damage.call_deferred(damage)
			else:
				return
		shot_type.PROJ: #Projectile
			var currentprojectile = nail.instantiate()
			add_child(currentprojectile)
	
	animations.play("shoot")
	can_shoot = false
	await animations.animation_finished
	can_shoot = true
	
