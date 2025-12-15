extends Node3D

@export var all_weapons: Array[Weapon]
var index = 0
var current_weapon: Weapon


func _ready() -> void:
	current_weapon = all_weapons[0]
	current_weapon.equip()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("scrollup"):
		index = min(index + 1, all_weapons.size() - 1)
		current_weapon.unequip()
		current_weapon = all_weapons[index]
		current_weapon.equip()
	
	if Input.is_action_pressed("scrolldown"):
		index = max(index - 1, 0)
		current_weapon.unequip()
		current_weapon = all_weapons[index]
		current_weapon.equip()
		
	if Input.is_action_just_pressed("shoot"):
		current_weapon.shoot()
