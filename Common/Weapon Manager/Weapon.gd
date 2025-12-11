extends Node3D
class_name Weapon

enum ShootType {Hitscan, Projectile}

#--Export--
@export var Name: String
@export var Damage: int
@export_category("Animation Player")
@export var Animations: AnimationPlayer
@export_category("Audio Player")
@export var Audio: AudioStreamPlayer3D
@export_category("Model")
@export var Model : Weapon
@export_category("Type")
@export var Type: ShootType
#--Export end--

func enter():
	pass
func shoot():
	pass
func reload():
	pass
func altshoot():
	pass
