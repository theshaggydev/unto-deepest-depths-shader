extends CanvasLayer

@onready var shader_rect: ColorRect = $shader_rect

func get_shader_param(param: String) -> float:
	return shader_rect.material.get_shader_parameter(param)

func set_shader_param(param: String, value: float) -> void:
	shader_rect.material.set_shader_parameter(param, value)
