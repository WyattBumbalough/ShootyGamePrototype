extends Node3D
class_name Weapon

var cleanliness: int = 50

func _ready() -> void:
	hide()

func equip():
	show()

func unequip():
	hide()
