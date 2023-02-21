extends Node

@export var DEMOS : Array[Resource]
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
