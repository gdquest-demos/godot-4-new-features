extends Node

@export var sounds : Array[AudioStream]

var available_player: Array[AudioStreamPlayer3D] = []
var busy_player: Array[AudioStreamPlayer3D] = []
var max_player : int = 16


func _ready() -> void:
	for i in max_player:
		var stream_player := AudioStreamPlayer3D.new()
		stream_player.max_db = 2.0
		stream_player.unit_size = 2.0
		
		stream_player.connect("finished", _on_player_finished.bind(stream_player))
		available_player.append(stream_player)
		add_child(stream_player)


func _on_player_finished(stream_player : AudioStreamPlayer3D) -> void:
	busy_player.erase(stream_player)
	available_player.append(stream_player)


func play_random_at(at_position : Vector3, intensity : float = 1.0) -> void:
	if available_player.is_empty(): return
	var stream_player : AudioStreamPlayer3D = available_player.pop_front()
	busy_player.append(stream_player)
	
	stream_player.global_position = at_position
	stream_player.stream = sounds.pick_random()
	stream_player.volume_db = remap(intensity, 0.0, 1.0, 0.0, 20.0)
	stream_player.play()
