extends CanvasLayer

@onready var shader_mesh: ColorRect = $"Shader Mesh"

func _ready() -> void:
	# Set Shader Values
	set_values()

func set_values() -> void:
	# Set Shader Resolution
	shader_mesh.size = Shortcuts.current_resolution
	# Send Shader Parameters
	var shader_material = shader_mesh.material
	shader_material.set_shader_parameter("disable", Shortcuts.disable_crt_shader)
	shader_material.set_shader_parameter("curvature", Shortcuts.curvature)
	shader_material.set_shader_parameter("blur", Shortcuts.blur)
	shader_material.set_shader_parameter("line_alpha", Shortcuts.line_alpha)
	shader_material.set_shader_parameter("line_subtleness", Shortcuts.line_subtleness)
	shader_material.set_shader_parameter("vignette_multiplier", Shortcuts.vignette_multiplier)
	shader_material.set_shader_parameter("vignette_border", Shortcuts.vignette_border)
	shader_material.set_shader_parameter("hori_res", Shortcuts.current_resolution.x)
	shader_material.set_shader_parameter("vert_res", Shortcuts.current_resolution.y)
