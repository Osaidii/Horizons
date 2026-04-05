extends CanvasLayer

@export var curvature = 6.0
@export var blur = 0.1
@export var line_alpha = 0.1
@export var line_subtleness = 1.0
@export var vignette_multiplier = 0.6
@export var vignette_border := 7.0

@onready var shader_mesh: MeshInstance2D = $"Shader Mesh"

func _ready() -> void:
	# Set Shader Values
	set_values()

func set_values() -> void:
	# Set Shader Values
	shader_mesh.mesh.size = GlobalVariables.current_resolution
	shader_mesh.mesh.center_offset.x = GlobalVariables.current_resolution.x / 2
	shader_mesh.mesh.center_offset.y = GlobalVariables.current_resolution.y / 2
	# Send Shader Parameters
	var shader_material = shader_mesh.material
	shader_material.set_shader_parameter("disable", GlobalVariables.disbale_crt_shader)
	shader_material.set_shader_parameter("curvature", curvature)
	shader_material.set_shader_parameter("blur", blur)
	shader_material.set_shader_parameter("line_alpha", line_alpha)
	shader_material.set_shader_parameter("line_subtleness", line_subtleness)
	shader_material.set_shader_parameter("vignette_multiplier", vignette_multiplier)
	shader_material.set_shader_parameter("vignette_border", vignette_border)
	shader_material.set_shader_parameter("hori_res", GlobalVariables.current_resolution.x)
	shader_material.set_shader_parameter("vert_res", GlobalVariables.current_resolution.y)
