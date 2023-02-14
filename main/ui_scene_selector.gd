extends CanvasLayer

const DEMOS := [
	{"scene_path": "res://2d_clipping/2d_clipping.tscn", "name": "2D Clipping"},
	{"scene_path": "res://3d_physics_nodes/3d_physics_nodes.tscn", "name": "3D Physics Nodes"},
	{"scene_path": "res://animation_retargeting/animation_retargeting.tscn", "name": "Animation Retargeting"},
	{"scene_path": "res://cutout_character/cutout_character.tscn", "name": "Cutout Character"}
]
const UI_SCENE_ENTRY_SCENE := preload("res://main/ui_scene_entry.tscn")

@onready var grid_container : GridContainer = $GridContainer
@onready var _cached_mouse_mode : int


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
	get_tree().change_scene_to_file(DEMOS[demo_id]["scene_path"])
	resume()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().current_scene == null:
			return
		if visible:
			resume()
		else:
			pause()


func pause() -> void:
	visible = true
	if get_tree().current_scene:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
		_cached_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	visible = false
	if get_tree().current_scene:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_ALWAYS
		Input.mouse_mode = _cached_mouse_mode
