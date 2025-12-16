extends Node3D
class_name Weapon

@export var animations: AnimationPlayer

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
	animations.play("shoot")
	can_shoot = false
	await animations.animation_finished
	can_shoot = true
	
