extends Node3D

const MAP_SIZE = 10.0

@export var map_resolution := 200
@export var height_ratio := 5.0

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var static_body : StaticBody3D = $StaticBody3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

@onready var heightmap_resolution_input : SpinBox = %HeightmapResolutionInput
@onready var maximum_height_input : SpinBox = %MaximumHeightInput
@onready var apply_button : Button = %ApplyButton


func _ready():
	_update_heightmap()
	apply_button.pressed.connect(_on_apply_pressed)
	heightmap_resolution_input.value = map_resolution
	maximum_height_input.value = height_ratio


func _on_apply_pressed() -> void:
	map_resolution = roundi(heightmap_resolution_input.value)
	height_ratio = maximum_height_input.value
	_update_heightmap()


func _update_heightmap() -> void:
	static_body.scale = Vector3.ONE * MAP_SIZE / float(map_resolution)
	
	var heightmap_shape := HeightMapShape3D.new()
	heightmap_shape.map_width = map_resolution
	heightmap_shape.map_depth = map_resolution

	var heightmap_image := Image.new()
	heightmap_image.load("res://heightmap_physics/heightmap.png")
	heightmap_image.resize(map_resolution, map_resolution, Image.INTERPOLATE_NEAREST)
	
	mesh_instance.material_override.set("shader_parameter/heightmap_texture", ImageTexture.create_from_image(heightmap_image))
	mesh_instance.material_override.set("shader_parameter/height_ratio", height_ratio)
	
	heightmap_image.convert(Image.FORMAT_RF)
	
	var data = heightmap_image.get_data().to_float32_array()
	var scale_multiplier := height_ratio/static_body.scale.x
	print(scale_multiplier)
	for i in range(data.size()):
		data[i] *= scale_multiplier

	heightmap_shape.map_data = data
	collision_shape.shape = heightmap_shape

