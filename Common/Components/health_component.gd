@icon("res://Assets/Icons/heart.png")
extends Node
class_name HealthComponent

signal damage_taken(amount)
signal health_reached_zero

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(_amount: float):
	current_health -= _amount
	damage_taken.emit(_amount)
	
	if current_health <= 0.0:
		health_reached_zero.emit()
