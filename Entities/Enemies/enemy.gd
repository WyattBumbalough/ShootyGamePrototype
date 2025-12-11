extends CharacterBody3D
class_name Enemy

@export var health: float
@export var type: Global.ENEMY_TYPES

@export_category("Nodes")
@export var animations: AnimationPlayer
@export var nav_agent: NavigationAgent3D
