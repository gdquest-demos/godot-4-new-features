extends Node3D

const MultiplayerSettings = preload("../common/multiplayer_settings.gd")
const Lobby = preload("../common/lobby.gd")
const PlayerBody = preload("player_body.gd")
const PlayerBodyScene = preload("player_body.tscn")

@onready var toggle_button: Button = %ToggleButton
@onready var lobby: VBoxContainer = %Lobby
@onready var multiplayer_settings: Node = %MultiplayerSettings


func _ready() -> void:
	toggle_button.toggled.connect(_on_menu_toggled)
	lobby.visible = toggle_button.button_pressed
	multiplayer_settings.player_added.connect(_on_player_added)
	multiplayer_settings.player_removed.connect(_on_player_removed)

func _on_menu_toggled(is_toggled: bool) -> void:
	lobby.visible = is_toggled


func _on_player_added(player: MultiplayerSettings.Player) -> void:
	if multiplayer.is_server():
		var player_body: PlayerBody = PlayerBodyScene.instantiate()
		player_body.id = player.id
		player_body.name = "player_%s_%s"%[player.nickname, player.id]
		add_child(player_body, true)


func _on_player_removed(player: MultiplayerSettings.Player) -> void:
	var player_name = "player_%s_%s"%[player.nickname, player.id]
	var player_body = get_node(player_name)
	if player_body != null:
		player_body.queue_free()
