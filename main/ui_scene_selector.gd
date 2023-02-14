extends CanvasLayer

const DEMOS := [
	{"scene_path": "res://2d_clipping/2d_clipping.tscn", "name": "2D Clipping"},
	{"scene_path": "res://3d_physics_nodes/3d_physics_nodes.tscn", "name": "3D Physics Nodes"},
	{"scene_path": "res://animation_retargeting/animation_retargeting.tscn", "name": "Animation Retargeting"},
	{"scene_path": "res://cutout_character/cutout_character.tscn", "name": "Cutout Character"},
	{"scene_path": "res://interior-diorama/interior_diorama.tscn", "name": "Interior Diorama"},
	{"scene_path": "res://outdoor_environment/outdoor_environment.tscn", "name": "Outdoor Environment"},
	{"scene_path": "res://theme_variations/theme_variations.tscn", "name": "Theme Variations"},
	{"scene_path": "res://tilemap/tilemap_based_level.tscn", "name": "Tilemap Level"},
	{"scene_path": "res://tweens/tween_demo.tscn", "name": "Tween Demo"},
	{"scene_path": "res://ui_flexbox/flow_container_demo.tscn", "name": "Flow Container"}
]
const UI_SCENE_ENTRY_SCENE := preload("res://main/ui_scene_entry.tscn")

@onready var grid_container : GridContainer = $SelectorRoot/GridContainer
@onready var selector_root : Control = $SelectorRoot

@onready var _cached_mouse_mode : int
@onready var _current_scene_idx : int


func _ready():
	if get_tree().current_scene == self:
		get_tree().current_scene = null
	
	for i in range(DEMOS.size()):
		var entry : Button = UI_SCENE_ENTRY_SCENE.instantiate()
		grid_container.add_child(entry)
		entry = grid_container.get_child(i)
		entry.label.text = DEMOS[i]["name"]
		entry.pressed.connect(_on_entry_pressed.bind(i))

	grid_container.get_child(0).grab_focus()


func _on_entry_pressed(demo_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_cached_mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file(DEMOS[demo_id]["scene_path"])
	_current_scene_idx = demo_id
	resume()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().current_scene == null:
			return
		if visible:
			resume()
		else:
			pause()
			grid_container.get_child(_current_scene_idx).grab_focus()


func pause() -> void:
	visible = true
	selector_root.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.tween_property(selector_root, "modulate", Color.WHITE, 0.2)
	
	if get_tree().current_scene:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
		_cached_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	selector_root.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(selector_root, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(set_visible.bind(false))
	
	if get_tree().current_scene:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_ALWAYS
		Input.mouse_mode = _cached_mouse_mode
