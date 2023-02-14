extends Panel

const Cursor = preload("cursor.gd")
const MultiplayerSettings = preload("../common/multiplayer_settings.gd")

var points_list: Array[Array] = []

func add_point(point_position: Vector2, point_color: Color, point_size: float) -> void:
	if get_rect().has_point(point_position):
		points_list.append([point_position, point_size, point_color])
		queue_redraw()


func add_player(player: MultiplayerSettings.Player) -> void:
		var cursor: Cursor = preload("cursor.tscn").instantiate()
		cursor.nickname = player.nickname
		cursor.color = player.color
		cursor.control_scheme = cursor.CONTROL_SCHEME.CURSOR
		cursor.id = player.id
		cursor.name = str(player.id)
		add_child(cursor, true)
		cursor.point_requested.connect(add_point)


func _draw() -> void:
	for point in points_list:
		draw_circle.callv(point)


## TODO: REMOVE
class Point:
	var position := Vector2.ZERO
	var color := Color.BLACK
	var size := 2.0
	
	func setup(initial_position: Vector2, initial_color: Color, initial_size: float = 2.0) -> Point:
		position = initial_position
		color = initial_color
		size = initial_size
		return self
		
	func _to_string() -> String:
		return "{%s:%s:%s}"%[position, size, color]
