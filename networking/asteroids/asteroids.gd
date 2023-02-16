extends Node2D

const Ship = preload("ship.gd")
const ADDRESS = "127.0.0.1"
const PORT = 4343


@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton


func _ready() -> void:
	host_button.pressed.connect(
		func on_host_pressed() -> void:
			multiplayer.peer_connected.connect(_spawn_player)
			var peer = ENetMultiplayerPeer.new()
			peer.create_server(PORT)
			multiplayer.multiplayer_peer = peer
			_spawn_player(1)
			host_button.disabled = true
			join_button.hide()
	, CONNECT_ONE_SHOT
	)
	join_button.pressed.connect(
		func on_join_pressed() -> void:
			var peer = ENetMultiplayerPeer.new()
			peer.create_client(ADDRESS, PORT)
			multiplayer.multiplayer_peer = peer
			host_button.hide()
			join_button.disabled = true
	, CONNECT_ONE_SHOT
	)


func _spawn_player(id: int):
	if not multiplayer.is_server():
		return
	var ship: Ship = preload("ship.tscn").instantiate()
	ship.is_multiplayer = true
	ship.name = str(id)
	ship.color = Color.ORANGE_RED if id == 1 else Color.GREEN
	ship.nickname = "Host" if id == 1 else "Player"
	var area := get_viewport_rect().size - (Vector2.ZERO * 32)
	ship.position = Vector2(randf_range(32, area.x), randf_range(32, area.y))
	add_child(ship)


func _process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var shoot_request := Input.is_action_pressed("ui_accept")
	if direction != Vector2.ZERO or shoot_request:
		_request_ship_action.rpc(direction, shoot_request)


@rpc("any_peer", "call_local")
func _request_ship_action(direction, shoot_request) -> void:
	# This method is called from anywhere, including the server, but runs only
	# on the server. The server puppets all the nodes, and they are replicated
	# on player's machines
	if not multiplayer.is_server():
		return
	var id = multiplayer.get_remote_sender_id()
	var ship: Ship = get_node(str(id))
	if ship == null:
		push_error("moving ship %s not found"%[id])
		return
	ship.move(direction)
	if shoot_request:
		ship.shoot()
