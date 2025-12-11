@tool
@icon("res://Assets/Icons/spawner.png")
extends Node3D
class_name Spawner

@export var scene: PackedScene

@onready var pop: AudioStreamPlayer3D = $Pop

var active: bool = true

func _ready() -> void:
	$Mesh.hide()
	
	#spawn_entity(scene)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Mesh.visible = true
		$Mesh/arrow.rotation.y += 0.01

func spawn_entity(_scene: PackedScene):
	var instance = _scene.instantiate()
	add_child(instance)
	
	pop.pitch_scale = randf_range(0.85, 1.15)
	pop.play()
