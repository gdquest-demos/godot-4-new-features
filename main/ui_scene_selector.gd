extends Node

const DEMOS := [
	{"path": "res://2d_clipping/2d_clipping.tscn", "name": "2D Clipping"},
	{"path": "res://3d_physics_nodes/3d_physics_nodes.tscn", "name": "3D Physics Nodes"},
	{"path": "res://animation_retargeting/animation_retargeting.tscn", "name": "Animation Retargeting"},
	{"path": "res://cutout_character/cutout_character.tscn", "name": "Cutout Character"},
	{"path": "res://interior-diorama/interior_diorama.tscn", "name": "Interior Diorama"},
	{"path": "res://outdoor_environment/outdoor_environment.tscn", "name": "Outdoor Environment"},
	{"path": "res://theme_variations/theme_variations.tscn", "name": "Theme Variations"},
	{"path": "res://tilemap/tilemap_based_level.tscn", "name": "Tilemap Level"},
	{"path": "res://tweens/tween_demo.tscn", "name": "Tween Demo"},
	{"path": "res://ui_flexbox/flow_container_demo.tscn", "name": "Flow Container"}
]

@onready var main_menu : CanvasLayer = %MainMenu
@onready var scene_tree := get_tree()

@onready var _cached_mouse_mode : int
@onready var _current_scene_index : int


func _ready() -> void:
	if scene_tree.current_scene == self:
		scene_tree.current_scene = null
	main_menu.set_is_open(true)
	main_menu.card_selector.card_selected.connect(_on_entry_pressed)
	
	for demo in DEMOS:
		main_menu.card_selector.create_card(demo["name"])
	main_menu.card_selector.grid.get_child(0).grab_focus()


func _on_entry_pressed(demo_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_cached_mouse_mode = Input.MOUSE_MODE_VISIBLE
	scene_tree.change_scene_to_file(DEMOS[demo_id]["path"])
	_current_scene_index = demo_id
	resume()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if scene_tree.current_scene == null:
			return
		if not main_menu._is_open:
			pause()
			main_menu.card_selector.focus_current_card()
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
