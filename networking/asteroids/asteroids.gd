extends Node2D

const Ship = preload("ship.gd")
const ADDRESS = "127.0.0.1"
const PORT = 4343


@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton


func _ready() -> void:
	var disable_buttons := func disable_buttons() -> void:
		host_button.disabled = true
		join_button.disabled = true
		
	host_button.pressed.connect(
		func on_host_pressed() -> void:
			multiplayer.peer_connected.connect(_spawn_player)
			var peer = ENetMultiplayerPeer.new()
			peer.create_server(PORT)
			multiplayer.multiplayer_peer = peer
			_spawn_player(1)
			disable_buttons.call()
	, CONNECT_ONE_SHOT
	)
	join_button.pressed.connect(
		func on_join_pressed() -> void:
			var peer = ENetMultiplayerPeer.new()
			peer.create_client(ADDRESS, PORT)
			multiplayer.multiplayer_peer = peer
			disable_buttons.call()
	, CONNECT_ONE_SHOT
	)


func _spawn_player(id: int):
	if not multiplayer.is_server():
		return
	var ship: Ship = preload("ship.tscn").instantiate()
	ship.name = str(id)
	ship.color = Color.ORANGE_RED if id == 1 else Color.GREEN
	ship.nickname = "Host" if id == 1 else "Player"
	var area := get_viewport_rect()
	ship.position = Vector2(randf_range(0, area.size.x), randf_range(0, area.size.y))
	add_child(ship)


func _process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var shoot_request := Input.is_action_pressed("ui_accept")
	_move_ship.rpc(direction, shoot_request)

@rpc("any_peer", "call_remote")
func _move_ship(direction, shoot_request) -> void:
	var id = multiplayer.get_unique_id()
	var ship: Ship = get_node(str(id))
	if ship == null:
		push_error("id %s not found"%[id])
	ship.move(direction, shoot_request)
