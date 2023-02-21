extends Node2D

@onready var light: PointLight2D = %PointLight2D
@onready var energy_slider: HSlider = %EnergySlider
@onready var height_slider: HSlider = %HeightSlider


func _ready() -> void:
	energy_slider.value = light.energy
	height_slider.value = light.height

	energy_slider.value_changed.connect(
		func(value):
			light.energy = energy_slider.value
	)

	height_slider.value_changed.connect(
		func(value):
			light.height = height_slider.value
	)
