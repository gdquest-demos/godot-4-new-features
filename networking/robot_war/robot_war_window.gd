extends Window

var _player_uis = {}

const MultiplayerSettings = preload("../common/multiplayer_settings.gd")
const Lobby = preload("../common/lobby.gd")
const PlayerBody = preload("gdbot.gd")
const PlayerBodyScene = preload("gdbot.tscn")

@onready var toggle_button: Button = %ToggleButton
@onready var lobby: VBoxContainer = %Lobby
@onready var multiplayer_settings: Node = %MultiplayerSettings
@onready var spawner : MultiplayerSpawner = %MultiplayerSpawner
@onready var game_ui : HBoxContainer = %GameUI
@onready var input_grabber : Control = %InputGrabber


func _ready() -> void:
	close_requested.connect(_on_close_requested)
	toggle_button.toggled.connect(_on_menu_toggled)
	lobby.visible = toggle_button.button_pressed
	multiplayer_settings.player_added.connect(_on_player_added)
	multiplayer_settings.player_removed.connect(_on_player_removed)
	input_grabber.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.is_pressed():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	)
	
	# This function will run on the network
	spawner.spawn_function = func spawn_player_custom(data: Array) -> PlayerBody:
		if typeof(data) != TYPE_ARRAY or data.size() != 3 \
		or typeof(data[0]) != TYPE_INT \
		or typeof(data[1]) != TYPE_STRING \
		or typeof(data[2]) != TYPE_COLOR:
			push_error("Invalid spawn")
			return null
		var id: int = data[0]
		var nickname: String = data[1]
		var color: Color = data[2]
		var player_body: PlayerBody = PlayerBodyScene.instantiate()
		player_body.nickname = nickname
		player_body.name = str(id)
		player_body.color = color
		player_body.position = Vector3(randf_range(-10, 10), 5, randf_range(-10, 10))
		return player_body


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_close_requested() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	queue_free()


func _on_menu_toggled(is_toggled: bool) -> void:
	lobby.visible = is_toggled


func _on_player_added(player: MultiplayerSettings.PeerPlayer) -> void:
	game_ui.show()
	lobby.visible = false
	
	var player_ui = game_ui.get_child(0) if player.is_host else game_ui.get_child(1)
	player_ui.set_player_name(player.nickname)
	_player_uis[str(player.id)] = player_ui
	
	if get_viewport().multiplayer.is_server():
		# this uses the custom function `spawn_player_custom`
		spawner.spawn([player.id, player.nickname, player.color])


func _on_player_removed(player_id: int) -> void:
	var player_body := get_node_or_null("player_%s"%[player_id])
	if player_body != null:
		player_body.queue_free()


func set_as_host() -> void:
	lobby.is_server_check_button.button_pressed = true
	lobby.is_server_check_button.pressed.emit()


func register_player(player: PlayerBody) -> void:
	_player_uis[player.name].set_portrait_color(player.color)
	get_tree().process_frame.connect(
		func():
			_player_uis[player.name].update_damage(player.damage_amount)
	)
