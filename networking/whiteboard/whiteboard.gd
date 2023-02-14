extends Control

const MultiplayerSettings = preload("../common/multiplayer_settings.gd")
const Lobby = preload("../common/lobby.gd")

@onready var lobby: Lobby = %Lobby
@onready var paint_canvas: Control = %PaintCanvas
@onready var multiplayer_settings: MultiplayerSettings = %MultiplayerSettings

func _ready() -> void:
	multiplayer_settings.player_added.connect(paint_canvas.add_player)


