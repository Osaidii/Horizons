extends Node

var current_resolution := Vector2(1920, 1080)
var design_resolution := Vector2(1280, 720)

# Levels
var intro_complete: bool
var domain_1_complete: bool
var domain_2_complete: bool
var domain_3_complete: bool

# Shortcut using Variables (Signal Substitute)
var increase_flashlight_battery: int
var flash_light_unlocked: bool
var disable_crt_shader: bool
var curvature: float
var blur: float
var line_alpha: float
var line_subtleness: float
var vignette_multiplier: float
var vignette_border: float
