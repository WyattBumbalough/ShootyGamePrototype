extends Area3D
class_name HurtboxComponent

@export var damage: float = 10.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

func _on_area_entered(area: Area3D):
	if area is HitboxComponent:
		
		area.take_damage(damage)
