extends Node

@export var target_mesh : MeshInstance3D
@export var lod_curve : Curve
var _is_grabbing := false

var relative_value = 1.0

@onready var footer = %Footer

@onready var camera_3d = %Camera3D
@onready var bg_plane = %BGPlane


func _ready():
	set_fake_lod(relative_value)
	set_bg_ratio()
	get_viewport().connect("size_changed", set_bg_ratio)
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton: 
		_is_grabbing = event.pressed
	if not (event is InputEventMouseMotion):
		return
	if not _is_grabbing: 
		return

	var viewport = get_viewport()
	# var mouse_y = clamp(viewport.get_mouse_position().y / viewport.size.y, 0.0, 1.0)
	relative_value = clamp(relative_value + event.relative.x / viewport.size.x, 0.0, 1.0)
	set_fake_lod(relative_value)
	
func set_fake_lod(value : float):
	
	target_mesh.lod_bias = lod_curve.sample(value * 0.5)
	
	footer.anchor_left = remap(value, 0.0, 1.0, 0.0, 0.4)
	footer.anchor_right = remap(value, 0.0, 1.0, 1.0, 0.6)


func set_bg_ratio():
	var frustum_height = tan(camera_3d.fov * PI / 180 * 0.5) * (camera_3d.position.z - bg_plane.position.z) * 2
	var viewport_size = get_viewport().size
	var ratio = float(viewport_size.x) / float(viewport_size.y)

	bg_plane.mesh.size.x = frustum_height * ratio
	bg_plane.mesh.size.y = frustum_height
