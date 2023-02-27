extends Node

const MainMenu := preload("res://main/menu_scene_selector/main_menu.gd")

@onready var main_menu: MainMenu = %MainMenu
@onready var scene_tree := get_tree()

@onready var _cached_mouse_mode : Input.MouseMode
@onready var _current_scene_index : int

var DEMOS : Array[DemoData] = [
	DemoData.setup(
		"2d_clipping", 
		preload("./thumbnails/2d_clipping_thumbnail.png"), 
		preload("res://2d_clipping/2d_clipping_background.tscn").resource_path,
		"Demonstrates how you can use a texture to clip parts of another"
	),
	DemoData.setup(
		"2D Dynamic Lighting", 
		preload("./thumbnails/2d_dynamic_lights.png"), 
		preload("res://2d_dynamic_lights/2d_dynamic_lights.tscn").resource_path,
		"Shows an animated 2D light projecting shadows"
	),
	DemoData.setup(
		"2D Lighting Normal Map", 
		preload("./thumbnails/2d_lighting_normal_map.png"), 
		preload("res://2d_lighting_normal_map/2d_lighting_normal_map.tscn").resource_path,
		"Demonstrates a directional 2D light creating 2D shadows in real time"
	),
	DemoData.setup(
		"2D Particles", 
		preload("./thumbnails/2d_particles.png"), 
		preload("res://2d_particles/rain.tscn").resource_path,
		"Particles used to create rain that falls and bounces on a tilemap level"
	),
	DemoData.setup(
		"2D Physics Benchmark", 
		preload("./thumbnails/2d_physics_benchmark.png"), 
		preload("res://2d_physics_benchmark/2d_physics_benchmark.tscn").resource_path,
		"Spawns plenty of round shapes to test physics"
	),
	DemoData.setup(
		"3D Animation Tree Audio", 
		preload("./thumbnails/3d_animation_tree_audio.png"), 
		preload("res://3d_animation_tree_audio/3d_animation_tree_audio.tscn").resource_path,
		"Control Sofia with WASD: Demonstrates how sounds easily overlap now"
	),
	DemoData.setup(
		"3D Balls Pool", 
		preload("./thumbnails/ball_pool_thumbnail.png"), 
		preload("res://3d_balls_pool/3d_balls_pool.tscn").resource_path,
		"Click to spawn 3D balls in this 3D physics benchmark"
	),
	# TODO: set up 3D particles scene
	#DemoData.setup(
	#	"3D Particles", 
	#	preload("./thumbnails/.png"), 
	#	preload("res://3d_balls_pool/3d_balls_pool.tscn").resource_path,
	#	"blah blah description"
	#),
	DemoData.setup(
		"3D Physics Nodes", 
		preload("./thumbnails/3d_physics_nodes.png"), 
		preload("res://3d_physics_nodes/3d_physics_nodes.tscn").resource_path,
		"Control Sofia with WASD and move balls around"
	),
	DemoData.setup(
		"animation_retargeting", 
		preload("./thumbnails/animation_retargeting_thumbnail.png"), 
		preload("res://animation_retargeting/animation_retargeting.tscn").resource_path,
		"3 completely different meshes dance for you"
	),
	DemoData.setup(
		"Audio Polyphony", 
		preload("./thumbnails/audio_polyphony.png"),
		preload("res://audio_polyphony/audio_polyphony.tscn").resource_path,
		"TODO"
	),
	DemoData.setup(
		"Canvas Group", 
		preload("./thumbnails/canvas_group_thumbnail.png"), 
		preload("res://cutout_character/cutout_character.tscn").resource_path,
		"A group of nodes fades out; the one using canvas groups shows no overlaps"
	),
	DemoData.setup(
		"Multilingual", 
		preload("./thumbnails/multilingual_thumbnail.png"), 
		preload("res://dialogue_tree/dialogue_tree_ui.tscn").resource_path,
		"Check how unicode characters display properly in UI nodes and buttons; You can also scale the font dynamically"
	),
	
	DemoData.setup(
		"Heightmap Physics", 
		preload("./thumbnails/heightmap_thumbnail.png"), 
		preload("res://heightmap_physics/heightmap_physics.tscn").resource_path,
		"[Click] to generate a random mountain, and press [SPACE] to drop balls. Demonstrates how heightmaps can affect physics"
	),
	DemoData.setup(
		"Voxel GI", 
		preload("./thumbnails/voxelgi_thumbnail.png"), 
		preload("res://interior-diorama/interior_diorama.tscn").resource_path,
		"Rotate the room around. A simple setup to demonstrate the results that can be obtained using VoxelGI"
	),
	# TODO: verify why this isn't working
	# DemoData.setup(
	# 	"Networking", 
	# 	preload("./thumbnails/.png"), 
	# 	preload("res://networking/robot_war/robot_war.tscn").resource_path,
	# "test test test"
	# ),
	DemoData.setup(
		"Environment", 
		preload("./thumbnails/environment.png"), 
		preload("res://outdoor_environment/outdoor_environment.tscn").resource_path,
		"TODO"
	),
	DemoData.setup(
		"Theme Variations", 
		preload("./thumbnails/theme_variations.png"), 
		preload("res://theme_variations/theme_variations.tscn").resource_path,
		"The scene isn't interactive, but you can see how it works by opening it in the editor"
	),
	DemoData.setup(
		"Tilemap", 
		preload("./thumbnails/tilemap.png"), 
		preload("res://tilemap/tilemap_based_level.tscn").resource_path,
		"An example of a tilemap scene. Use WASD to move the character around"
	),
	DemoData.setup(
		"Tweens", 
		preload("./thumbnails/tween.png"), 
		preload("res://tweens/tween_demo.tscn").resource_path,
		"Click somewhere to move the ship and collect the rupees"
	),
	DemoData.setup(
		"Flow Container", 
		preload("./thumbnails/flow_container.png"), 
		preload("res://ui_flexbox/flow_container_demo.tscn").resource_path,
		"Add or remove items and see how they neatly stack next to each other dynamically"
	),
]

func _ready() -> void:
	if scene_tree.current_scene == self:
		scene_tree.current_scene = null
	main_menu.set_is_open(true)
	main_menu.card_selector.card_selected.connect(_on_entry_pressed)
	
	for demo in DEMOS:
		main_menu.card_selector.create_card(demo.title, demo.thumbnail, demo.description)
	main_menu.card_selector.grid.get_child(0).grab_focus()


const HintText = preload("res://main/menu_scene_selector/hint_text.gd")
const HintTextScene = preload("res://main/menu_scene_selector/hint_text.tscn")


func _get_card_hints() -> Array[HintText]:
	var nodes: Array[HintText] = []
	nodes.assign(get_tree().get_nodes_in_group("card_hints") as Array[HintText])
	return nodes


func _on_entry_pressed(demo_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_cached_mouse_mode = Input.MOUSE_MODE_VISIBLE

	var demo: DemoData = DEMOS[demo_id]
	var scene: PackedScene = load(demo.scene_path)
	var node := scene.instantiate()
	if scene_tree.current_scene:
		scene_tree.current_scene.queue_free()
	scene_tree.root.add_child(node)
	scene_tree.current_scene = node
	_current_scene_index = demo_id
	var hint: HintText = HintTextScene.instantiate()
	var layer := CanvasLayer.new()
	layer.add_child(hint)
	node.add_child(layer)
	hint.title = demo.title
	hint.text = demo.description
	hint.logo_visible = true
	hint.general_instructions_visible = true
	hint.custom_minimum_size = Vector2(420, 0)
	resume()
	await get_tree().physics_frame
	await get_tree().physics_frame
	hint.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_WIDTH, 20)


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
	_get_card_hints().map(func(hint_node): 
		hint_node.visible = true
		hint_node.popout(true)
	)
	if scene_tree.current_scene != null:
		scene_tree.current_scene.process_mode = Node.PROCESS_MODE_DISABLED
		_cached_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	main_menu.set_is_open(false)
	_get_card_hints().map(func(hint_node): 
		hint_node.visible = false
		hint_node.popout(true)
	)
	if scene_tree.current_scene:
		scene_tree.current_scene.process_mode = Node.PROCESS_MODE_ALWAYS
		Input.mouse_mode = _cached_mouse_mode
