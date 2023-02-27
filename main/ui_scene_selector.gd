extends Node

const MainMenu := preload("res://main/menu_scene_selector/main_menu.gd")

@onready var main_menu: MainMenu = %MainMenu
@onready var scene_tree := get_tree()

@onready var _cached_mouse_mode : Input.MouseMode
@onready var _current_scene_index : int

var DEMOS : Array[DemoData] = [
	DemoData.setup(
		"2D clipping", 
		preload("./thumbnails/2d_clipping_thumbnail.png"), 
		preload("res://2d_clipping/2d_clipping_background.tscn").resource_path
	),
	DemoData.setup(
		"2D Dynamic Lighting", 
		preload("./thumbnails/2d_dynamic_lights.png"), 
		preload("res://2d_dynamic_lights/2d_dynamic_lights.tscn").resource_path
	),
	DemoData.setup(
		"2D Lighting Normal Map", 
		preload("./thumbnails/2d_lighting_normal_map_thumbnail.png"), 
		preload("res://2d_lighting_normal_map/2d_lighting_normal_map.tscn").resource_path
	),
	DemoData.setup(
		"2D Particles Collision", 
		preload("./thumbnails/2d_particles_thumbnail.png"), 
		preload("res://2d_particles/rainy_night.tscn").resource_path
	),
	DemoData.setup(
		"2D Physics Benchmark", 
		preload("./thumbnails/2d_physics_benchmark.png"), 
		preload("res://2d_physics_benchmark/2d_physics_benchmark.tscn").resource_path
	),
	DemoData.setup(
		"3D Animation Tree Audio", 
		preload("./thumbnails/3d_animation_tree_audio.png"), 
		preload("res://3d_animation_tree_audio/3d_animation_tree_audio.tscn").resource_path
	),
	DemoData.setup(
		"3D Balls Pool", 
		preload("./thumbnails/ball_pool_thumbnail.png"), 
		preload("res://3d_balls_pool/3d_balls_pool.tscn").resource_path
	),
	# TODO: set up 3D particles scene
	#DemoData.setup(
	#	"3D Particles", 
	#	preload("./thumbnails/.png"), 
	#	preload("res://3d_balls_pool/3d_balls_pool.tscn").resource_path
	#),
	DemoData.setup(
		"3D Physics Nodes", 
		preload("./thumbnails/3d_physics_nodes.png"), 
		preload("res://3d_physics_nodes/3d_physics_nodes.tscn").resource_path
	),
	DemoData.setup(
		"Animation retargeting", 
		preload("./thumbnails/animation_retargeting_thumbnail.png"), 
		preload("res://animation_retargeting/animation_retargeting.tscn").resource_path
	),
	DemoData.setup(
		"Audio Polyphony", 
		preload("./thumbnails/audio_polyphony.png"),
		preload("res://audio_polyphony/audio_polyphony.tscn").resource_path
	),
	DemoData.setup(
		"Canvas Group", 
		preload("./thumbnails/canvas_group_thumbnail.png"), 
		preload("res://cutout_character/cutout_character.tscn").resource_path
	),
	DemoData.setup(
		"Multilingual", 
		preload("./thumbnails/multilingual_thumbnail.png"), 
		preload("res://dialogue_tree/dialogue_tree_ui.tscn").resource_path
	),
	
	DemoData.setup(
		"Heightmap Physics", 
		preload("./thumbnails/heightmap_thumbnail.png"), 
		preload("res://heightmap_physics/heightmap_physics.tscn").resource_path
	),
	DemoData.setup(
		"Voxel GI", 
		preload("./thumbnails/voxelgi_thumbnail.png"), 
		preload("res://interior-diorama/interior_diorama.tscn").resource_path
	),
	# TODO: verify why this isn't working
	# DemoData.setup(
	# 	"Networking", 
	# 	preload("./thumbnails/.png"), 
	# 	preload("res://networking/robot_war/robot_war.tscn").resource_path
	# ),
	DemoData.setup(
		"Environment", 
		preload("./thumbnails/environment.png"), 
		preload("res://outdoor_environment/outdoor_environment.tscn").resource_path
	),
	DemoData.setup(
		"Theme Variations", 
		preload("./thumbnails/theme_variations.png"), 
		preload("res://theme_variations/theme_variations.tscn").resource_path
	),
	DemoData.setup(
		"Tilemap", 
		preload("./thumbnails/tilemap.png"), 
		preload("res://tilemap/tilemap_based_level.tscn").resource_path
	),
	DemoData.setup(
		"Tweens", 
		preload("./thumbnails/tweens_thumbnail.png"), 
		preload("res://tweens/tween_demo.tscn").resource_path
	),
	DemoData.setup(
		"Flow Container", 
		preload("./thumbnails/flow_container.png"), 
		preload("res://ui_flexbox/flow_container_demo.tscn").resource_path
	),
	DemoData.setup(
		"Info & Credits", 
		preload("./thumbnails/thanks.png"), 
		preload("res://main/thanks/thanks.tscn").resource_path
	),
]

func _ready() -> void:
	if scene_tree.current_scene == self:
		scene_tree.current_scene = null
	main_menu.set_is_open(true)
	main_menu.card_selector.card_selected.connect(_on_entry_pressed)
	
	for demo in DEMOS:
		main_menu.card_selector.create_card(demo.title, demo.thumbnail)
	main_menu.card_selector.grid.get_child(0).grab_focus()


func _on_entry_pressed(demo_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_cached_mouse_mode = Input.MOUSE_MODE_VISIBLE
	scene_tree.change_scene_to_file(DEMOS[demo_id].scene_path)
	_current_scene_index = demo_id
	resume()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if scene_tree.current_scene == null:
			return
		if not main_menu._is_open:
			pause()
		else:
			resume()
	if event.is_action_pressed("menu_quit"):
		get_tree().quit()


func pause() -> void:
	main_menu.set_is_open(true)
	
	if scene_tree.current_scene != null:
		scene_tree.current_scene.process_mode = Node.PROCESS_MODE_DISABLED
		_cached_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	main_menu.set_is_open(false)
	
	if scene_tree.current_scene:
		scene_tree.current_scene.process_mode = Node.PROCESS_MODE_ALWAYS
		Input.mouse_mode = _cached_mouse_mode
