@icon("res://Assets/Icons/target.png")
extends MeshInstance3D
class_name NavPoint

var claimed: bool = false

var mat: Material

func _ready() -> void:
	#mat = get_surface_override_material(0)
	mat = StandardMaterial3D.new()
	mat.albedo_color = Color.GREEN
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	set_surface_override_material(0, mat)
	
	
func claim():
	if claimed: 
		printerr("Navpoint " + name + " is already claimed!")
		return
	claimed = true
	get_surface_override_material(0).albedo_color = Color.RED

func release():
	if !claimed:
		printerr("Navpoint " + name + " has not been claimed!")
		return
	claimed = false
	get_surface_override_material(0).albedo_color = Color.GREEN
