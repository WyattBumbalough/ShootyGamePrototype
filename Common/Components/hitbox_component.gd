@icon("res://Assets/Icons/owie.png")
extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent

func take_damage(amount: float):
	health_component.take_damage(amount)
