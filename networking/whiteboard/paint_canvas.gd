extends Panel

const Cursor = preload("cursor.gd")
const MultiplayerSettings = preload("../common/multiplayer_settings.gd")

var points_list: Array[Point] = []

func add_point(point_position: Vector2, point_color: Color, point_size: float) -> void:
	if get_rect().has_point(point_position):
		_add_point.rpc([point_position, point_size, point_color])


@rpc("any_peer", "call_local")
func _add_point(data: Array) -> void:
	if typeof(data) != TYPE_ARRAY or data.size() != 3 \
	or typeof(data[0]) != TYPE_VECTOR2 \
	or typeof(data[1]) != TYPE_FLOAT \
	or typeof(data[2]) != TYPE_COLOR:
		push_error("Invalid spawn")
		return
	var point := Point.new()
	point.setup.callv(data)
	points_list.append(point)
	queue_redraw()


func add_player(player: MultiplayerSettings.PeerPlayer) -> void:
		var cursor: Cursor = preload("cursor.tscn").instantiate()
		cursor.nickname = player.nickname
		cursor.color = player.color
		cursor.control_scheme = cursor.CONTROL_SCHEME.CURSOR
		cursor.name = str(player.id)
		var multiplayer_synchronizer: MultiplayerSynchronizer = cursor.get_node("MultiplayerSynchronizer")
		multiplayer_synchronizer.set_multiplayer_authority(player.id)
		add_child(cursor, true)
		cursor.point_requested.connect(add_point)


func _draw() -> void:
	for point in points_list:
		draw_circle(point.position, point.size, point.color)


class Point:
	var position := Vector2.ZERO
	var color := Color.BLACK
	var size := 2.0
	
	func setup(initial_position: Vector2, initial_size: float, initial_color: Color) -> Point:
		position = initial_position
		color = initial_color
		size = initial_size
		return self
		
	func _to_string() -> String:
		return "{%s:%s:%s}"%[position, size, color]
