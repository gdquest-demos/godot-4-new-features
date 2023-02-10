extends Node

# TODO: This is mostly redundant with the multiplayer state. Can we squish it?
enum STATUS {
	NONE,
	CONNECTING,
	CONNECTED,
	ERROR
}

## Used in messages that communicate state changes
enum MESSAGE_TYPE {
	INFO,
	SUCCESS,
	WARNING,
	ERROR,
}

## Maximum allowed number of clients
const MAX_CLIENTS = 10
## Server ID is always 1
const SERVER_PEER_ID = 1
## When calling an RPC method in a non-RPC way, the `get_remote_sender_id()`
## method always returns 0
const NOT_A_PEER_ID = 0

## Emitted when the manager needs to communicate a change
signal status_message_emitted(message: String, type: MESSAGE_TYPE)
## Emitted when the status is changed to one of STATUS constants 
signal status_changed
## Emitted when connected to the server (includes the server itself)
signal connected
## Emitted when disconnected from the server (includes the server itself)
signal disconnected
## Emitted when a player enters the network (includes self)
signal player_added(player: Player)
## Emitted when a player exits the network (includes self)
signal player_removed(player_id: int)
## Emitted when a player sends a message to everyone
signal player_sent_text(player: Player, message: String)


## The server's public IP
var address := "localhost"
## A random port between 1024 and 65535
var port := 8910
## Automatically set to true if Godot is running in headless mode
var is_server := DisplayServer.get_name() == "headless"
## A generated nickname for the player
var nickname: String = ["Brave", "Horrific", "Courageous", "Terrific", "Fair", "Conqueror", "Victorious", "Glorious", "Invicible"].pick_random() + ["Leopard", "Cheetah", "Bear", "Turtle", "Rabbit", "Porcupine", "Hare", "Pigeon", "Albatross", "Crow" ].pick_random()
## All connected players will be listed here
## Matches a player id with a Player instance
## @type Dictionary[Int, Player]
var players := {}
## Tracks the current status
var status: STATUS = STATUS.NONE :
	set(new_status):
		if new_status != status:
			status = new_status
			status_changed.emit()


func _ready() -> void:
	# we're setting the same multiplayer for the entire tree, but you could set it
	# on any branch
	var multiplayer_api := get_tree().root.multiplayer

	# You can save bandwith by disabling server relay and player notifications.
	multiplayer_api.server_relay = false

	# listening to events
	multiplayer_api.peer_connected.connect(_on_player_connected)
	multiplayer_api.peer_disconnected.connect(_on_player_disconnected)
	multiplayer_api.connected_to_server.connect(_on_connected_to_server)
	multiplayer_api.connection_failed.connect(_on_connection_failed)
	multiplayer_api.server_disconnected.connect(_on_server_disconnected)


## Connects the player to the network, or starts a server
func start_session() -> void:
	var multiplayer_peer := ENetMultiplayerPeer.new()
	var error := \
		multiplayer_peer.create_server(port, MAX_CLIENTS) \
		if is_server else \
		multiplayer_peer.create_client(address, port)
	if error != OK:
		status = STATUS.ERROR
		match error:
			ERR_ALREADY_IN_USE:
				status_message_emitted.emit("Already connected", MESSAGE_TYPE.ERROR)
			ERR_CANT_CREATE:
				status_message_emitted.emit("Could not create connection", MESSAGE_TYPE.ERROR)
			_:
				status_message_emitted.emit("Unknown error: %s"%[error], MESSAGE_TYPE.ERROR)
		return
	# This branch is never true because we're checking `error` above, but we leave
	# it to demonstrate another way to handle problems.
	if multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		status_message_emitted.emit("Failed to start multiplayer server", MESSAGE_TYPE.ERROR)
		return
	
	# we're setting the same multiplayer for the entire tree, but you could set it
	# on any branch
	var multiplayer_api := get_tree().root.multiplayer
	multiplayer_api.multiplayer_peer = multiplayer_peer

	status = STATUS.CONNECTING
	status_message_emitted.emit("Connecting...", MESSAGE_TYPE.WARNING)
	if is_server:
		# server is always connected to itself
		connected.emit()


## Disconnects the player from the network, or stops a server
func end_session() -> void:
	var multiplayer_api := get_tree().root.multiplayer
	multiplayer_api.multiplayer_peer.close()
	disconnected.emit()


@rpc("any_peer", "call_local")
func _register_player(player_nickname: String) -> void:
	var id := multiplayer.get_remote_sender_id()
	assert(id != NOT_A_PEER_ID, "this method should only be called from an RPC context")
	var player := Player.new()
	player.id = id
	player.nickname = player_nickname
	player.is_host = id == SERVER_PEER_ID
	players[id] = player

	var self_id := multiplayer.get_unique_id()
	if id == self_id:
		status_message_emitted.emit("set own nickame to: %s"%[player_nickname], MESSAGE_TYPE.INFO)
	else:
		status_message_emitted.emit("%s set nickame to: %s"%[id, player_nickname], MESSAGE_TYPE.INFO)
	player_added.emit(player)

## Sets the player's nickname
func register_player() -> void:
	_register_player.rpc(nickname)


@rpc("any_peer", "call_local")
func _dispatch_message(message: String) -> void:
	var id := multiplayer.get_remote_sender_id()
	assert(id != NOT_A_PEER_ID, "this method should only be called from an RPC context")
	if not players.has(id):
		return
	var player: Player = players[id]
	player_sent_text.emit(player, message)


## Dispatches a message to all players
func dispatch_message(message: String) -> void:
	_dispatch_message.rpc(message)


## Only on client
func _on_connected_to_server() -> void:
	status = STATUS.CONNECTED
	connected.emit()


## Only on client
func _on_connection_failed() -> void:
	status_message_emitted.emit("disconnected from server", MESSAGE_TYPE.ERROR)
	status = STATUS.NONE


## Only on client
func _on_server_disconnected() -> void:
	status_message_emitted.emit("disconnected from server", MESSAGE_TYPE.INFO)
	status = STATUS.NONE


func _on_player_connected(player_id: int) -> void:
	if player_id == SERVER_PEER_ID:
		status_message_emitted.emit("connected to server", MESSAGE_TYPE.SUCCESS)
	else:
		status_message_emitted.emit("player %s connected"%player_id, MESSAGE_TYPE.SUCCESS)
	register_player()


func _on_player_disconnected(player_id: int) -> void:
	if player_id == SERVER_PEER_ID:
		status_message_emitted.emit("disconnected from server", MESSAGE_TYPE.INFO)
	else:
		status_message_emitted.emit("player %s disconnected"%player_id, MESSAGE_TYPE.INFO)
	player_removed.emit(player_id)


class Player:
	var id: int
	var nickname: String
	var color := Color.from_hsv((randi() % 12) / 12.0, 1, 1)
	var is_host := false
	var prefix := "":
		get:
			return "@" if is_host else ""
