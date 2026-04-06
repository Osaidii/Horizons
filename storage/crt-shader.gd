extends CanvasLayer

@onready var shader_mesh: MeshInstance2D = $"Shader Mesh"
@onready var player: Player = $".."

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
	shader_material.set_shader_parameter("disable", player.disbale_crt_shader)
	shader_material.set_shader_parameter("curvature", player.curvature)
	shader_material.set_shader_parameter("blur", player.blur)
	shader_material.set_shader_parameter("line_alpha", player.line_alpha)
	shader_material.set_shader_parameter("line_subtleness", player.line_subtleness)
	shader_material.set_shader_parameter("vignette_multiplier", player.vignette_multiplier)
	shader_material.set_shader_parameter("vignette_border", player.vignette_border)
	shader_material.set_shader_parameter("hori_res", GlobalVariables.current_resolution.x)
	shader_material.set_shader_parameter("vert_res", GlobalVariables.current_resolution.y)
