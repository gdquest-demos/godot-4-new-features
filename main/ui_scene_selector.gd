extends Node

@onready var main_menu : CanvasLayer = %MainMenu
@onready var scene_tree := get_tree()

@onready var _cached_mouse_mode : Input.MouseMode
@onready var _current_scene_index : int

var DEMOS : Array[DemoData] = [
	DemoData.setup("2d_clipping", preload("./thumbnails/2d_clipping_thumbnail.png"), preload("res://2d_clipping/2d_clipping.tscn").resource_path),
	DemoData.setup("animation_retargeting", preload("./thumbnails/animation_retargeting_thumbnail.png"), preload("res://animation_retargeting/animation_retargeting.tscn").resource_path),
	DemoData.setup("Ball Pool", preload("./thumbnails/ball_pool_thumbnail.png"), preload("res://3d_balls_pool/3d_balls_pool.tscn").resource_path),
	DemoData.setup("canvas_group", preload("./thumbnails/canvas_group_thumbnail.png"), preload("res://cutout_character/cutout_character.tscn").resource_path),
	DemoData.setup("heightmap", preload("./thumbnails/heightmap_thumbnail.png"), preload("res://heightmap_physics/heightmap_physics.tscn").resource_path),
	DemoData.setup("multilingual", preload("./thumbnails/multilingual_thumbnail.png"), preload("res://dialogue_tree/dialogue_tree_ui.tscn").resource_path),
	DemoData.setup("voxelgi", preload("./thumbnails/voxelgi_thumbnail.png"), preload("res://interior-diorama/interior_diorama.tscn").resource_path),
]

func _ready() -> void:
	if scene_tree.current_scene == self:
		scene_tree.current_scene = null
	main_menu.set_is_open(true)
	main_menu.card_selector.card_selected.connect(_on_entry_pressed)
	
	for demo in DEMOS:
		main_menu.card_selector.create_card(demo["title"], demo["thumbnail"])
	main_menu.card_selector.grid.get_child(0).grab_focus()


func _on_entry_pressed(demo_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_cached_mouse_mode = Input.MOUSE_MODE_VISIBLE
	scene_tree.change_scene_to_file(DEMOS[demo_id]["scene_path"])
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
