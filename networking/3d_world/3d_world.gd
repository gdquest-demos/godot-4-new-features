extends Node3D

const MultiplayerSettings = preload("../common/multiplayer_settings.gd")
const Lobby = preload("../common/lobby.gd")
const PlayerBody = preload("player_body.gd")
const PlayerBodyScene = preload("player_body.tscn")

@onready var toggle_button: Button = %ToggleButton
@onready var lobby: VBoxContainer = %Lobby
@onready var multiplayer_settings: Node = %MultiplayerSettings
@onready var spawner : MultiplayerSpawner = %MultiplayerSpawner


func _ready() -> void:
	toggle_button.toggled.connect(_on_menu_toggled)
	lobby.visible = toggle_button.button_pressed
	multiplayer_settings.player_added.connect(_on_player_added)
	multiplayer_settings.player_removed.connect(_on_player_removed)
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
		player_body.position = Vector3(randf_range(-25, 25), 0, randf_range(-25, 25))
		return player_body


func _on_menu_toggled(is_toggled: bool) -> void:
	lobby.visible = is_toggled


func _on_player_added(player: MultiplayerSettings.PeerPlayer) -> void:
	if multiplayer.is_server():
		# this uses the custom function `spawn_player_custom`
		spawner.spawn([player.id, player.nickname, player.color])


func _on_player_removed(player_id: int) -> void:
	var player_body := get_node_or_null("player_%s"%[player_id])
	if player_body != null:
		player_body.queue_free()
