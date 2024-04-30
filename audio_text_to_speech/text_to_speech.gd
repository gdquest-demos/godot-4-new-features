extends Control

@onready var popup_menu: PopupMenu = %PopupMenu
@onready var play_button: Button = %PlayButton
@onready var line_edit: LineEdit = %LineEdit


func _ready():
	var voices := DisplayServer.tts_get_voices_for_language("en")
	
	if voices.size() == 0:
		return
	
	popup_menu.id_pressed.connect(_id_pressed)
	for voice in voices:
		popup_menu.add_item(voice)
	popup_menu.set_focused_item(0)
	_id_pressed(0)
	play_button.pressed.connect(_on_play_pressed)


func _id_pressed(id: int) -> void:
	popup_menu.name = popup_menu.get_item_text(id)


func _on_play_pressed() -> void:
	DisplayServer.tts_speak(line_edit.text, popup_menu.name)
