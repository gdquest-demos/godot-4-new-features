extends Node3D

const BALL_SCENE = preload("res://heightmap_physics/ball.tscn")
const MAP_SIZE = 10.0

@export var map_resolution := 200
@export var height_ratio := 5.0

@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var _static_body : StaticBody3D = $StaticBody3D
@onready var _collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var _balls_holder: Node3D = $Balls
@onready var _spawn_position: Node3D = $SpawnPosition

@onready var _heightmap_resolution_input : SpinBox = %HeightmapResolutionInput
@onready var _maximum_height_input : SpinBox = %MaximumHeightInput
@onready var _apply_button : Button = %ApplyButton


func _ready():
	_update_heightmap()
	_apply_button.pressed.connect(_on_apply_pressed)
	_heightmap_resolution_input.value = map_resolution
	_maximum_height_input.value = height_ratio


func _physics_process(_delta):
	if Input.is_action_pressed("jump"):

		var ball := BALL_SCENE.instantiate()
		_balls_holder.add_child(ball)
		ball.global_position = _spawn_position.global_position
		
		var impulse := randf_range(0.0, 3.0)
		ball.apply_central_impulse(Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized() * impulse)



func _on_apply_pressed() -> void:
	map_resolution = roundi(_heightmap_resolution_input.value)
	height_ratio = _maximum_height_input.value
	_update_heightmap()


func _update_heightmap() -> void:
	_static_body.scale = Vector3.ONE * MAP_SIZE / float(map_resolution)
	
	var heightmap_shape := HeightMapShape3D.new()
	heightmap_shape.map_width = map_resolution
	heightmap_shape.map_depth = map_resolution

	var heightmap_image := Image.new()
	heightmap_image.load("res://heightmap_physics/heightmap.png")
	heightmap_image.resize(map_resolution, map_resolution, Image.INTERPOLATE_NEAREST)
	
	_mesh_instance.material_override.set("shader_parameter/heightmap_texture", ImageTexture.create_from_image(heightmap_image))
	_mesh_instance.material_override.set("shader_parameter/height_ratio", height_ratio)
	
	heightmap_image.convert(Image.FORMAT_RF)
	
	var data = heightmap_image.get_data().to_float32_array()
	var scale_multiplier := height_ratio/_static_body.scale.x

	for i in range(data.size()):
		data[i] *= scale_multiplier

	heightmap_shape.map_data = data
	_collision_shape.shape = heightmap_shape

