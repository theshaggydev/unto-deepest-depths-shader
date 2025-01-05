extends Node2D

@onready var scanline_strength_slider: HSlider = %scanline_strength_slider
@onready var aberration_strength_slider: HSlider = %aberration_strength_slider
@onready var vignette_strength_slider: HSlider = %vignette_strength_slider
@onready var noise_strength_slider: HSlider = %noise_strength_slider
@onready var glow_strength_slider: HSlider = %glow_strength_slider
@onready var glow_radius_slider: HSlider = %glow_radius_slider
@onready var shader_toggle: CheckButton = %shader_toggle

func _ready() -> void:
	scanline_strength_slider.value = PostProcessing.get_shader_param('scanline_strength')
	aberration_strength_slider.value = PostProcessing.get_shader_param('aberration_amount')
	vignette_strength_slider.value = PostProcessing.get_shader_param('vignette_size')
	noise_strength_slider.value = PostProcessing.get_shader_param('noise_intensity')
	glow_strength_slider.value = PostProcessing.get_shader_param('glow_strength')
	glow_radius_slider.value = PostProcessing.get_shader_param('glow_radius')
	
	scanline_strength_slider.value_changed.connect(_on_slider_value_changed.bind('scanline_strength'))
	aberration_strength_slider.value_changed.connect(_on_slider_value_changed.bind('aberration_amount'))
	vignette_strength_slider.value_changed.connect(_on_slider_value_changed.bind('vignette_size'))
	noise_strength_slider.value_changed.connect(_on_slider_value_changed.bind('noise_intensity'))
	glow_strength_slider.value_changed.connect(_on_slider_value_changed.bind('glow_strength'))
	glow_radius_slider.value_changed.connect(_on_slider_value_changed.bind('glow_radius'))
	
	shader_toggle.button_pressed = true
	shader_toggle.toggled.connect(_on_shader_toggled)

func _on_slider_value_changed(value: float, param: String) -> void:
	PostProcessing.set_shader_param(param, value)

func _on_shader_toggled(on: bool) -> void:
	PostProcessing.visible = on
