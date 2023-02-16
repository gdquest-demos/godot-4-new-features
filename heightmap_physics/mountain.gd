extends Node3D

@export var top_colors : Gradient
@export var base_colors : Gradient

@export var heightmap_texture : NoiseTexture2D
@export var source_mesh : Mesh
@export var target_mesh_instance : MeshInstance3D
@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D
@onready var static_body_3d = $StaticBody3D

@onready var texture_size = heightmap_texture.get_size()
@onready var texture_image : Image

var mdt = MeshDataTool.new()

func _ready():
	_generate()

func _generate():
	heightmap_texture.noise.frequency = randfn(0.0035, 0.0025)
	heightmap_texture.noise.seed = randi()
	await heightmap_texture.changed
	texture_image = heightmap_texture.get_image()
	_compute_heightmap()
	var color_offset = randf()
	target_mesh_instance.material_override.set_shader_parameter("top_color", top_colors.sample(color_offset))
	target_mesh_instance.material_override.set_shader_parameter("base_color", base_colors.sample(color_offset))

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		_generate()
		
func _sample_xy(uv):
	var pixel : Color = texture_image.get_pixel(
		clamp(uv.x * texture_size.x, 0.0, texture_size.x - 1.0),
		clamp(uv.y * texture_size.y, 0.0, texture_size.y - 1.0)
	)
	var pixel_luminance = pixel.get_luminance()
	var uv_distance = uv.distance_to(Vector2(0.5, 0.5))
	uv_distance = smoothstep(0.5, 0.0, uv_distance)
	return pixel_luminance * uv_distance * 0.6
	
func _compute_heightmap():
	
	var base_resolution = 46
	
	var heightmap_shape = HeightMapShape3D.new()
	heightmap_shape.map_width = base_resolution
	heightmap_shape.map_depth = base_resolution
	
	for p_index in base_resolution * base_resolution:
		var x = (p_index % base_resolution) / float(base_resolution - 1.0)
		var y = floor(p_index / float(base_resolution)) / float(base_resolution - 1.0)
		var uv = Vector2(x,y)
		var uv_distance = uv.distance_to(Vector2(0.5, 0.5))
		var uv_mask = smoothstep(0.5, 1.0, uv_distance)
		
		heightmap_shape.map_data[p_index] += base_resolution * _sample_xy(uv)
		heightmap_shape.map_data[p_index] -= uv_mask * 20.0  
		
		
		
	collision_shape_3d.scale = Vector3.ONE * (1.0 / float(base_resolution))
	collision_shape_3d.shape = heightmap_shape
	

	var mesh = ArrayMesh.new()
	
	mdt.create_from_surface(source_mesh, 0)
	
	for vertex_index in mdt.get_vertex_count():
		var vertex_normal = mdt.get_vertex_normal(vertex_index)
		if vertex_normal.dot(Vector3.UP) < 0.1: continue
		var vertex_uv = mdt.get_vertex_uv(vertex_index)
		var vertex = mdt.get_vertex(vertex_index)
		var sample = _sample_xy(vertex_uv)
		vertex.y += sample 
		mdt.set_vertex(vertex_index, vertex)
		
	mdt.commit_to_surface(mesh)
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	surface_tool.generate_normals()

	target_mesh_instance.mesh = surface_tool.commit()
