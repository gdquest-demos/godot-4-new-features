extends CanvasLayer

const CardSelector = preload("res://main/menu_scene_selector/card_selector.gd")

@onready var animation_player = $AnimationPlayer

@onready var jingle_open = $JingleOpen
@onready var jingle_close = $JingleClose
@onready var jingle_select = $JingleSelect
@onready var arrow_button_sound = $ArrowButtonSound

@onready var card_selector: CardSelector = %CardSelector

var _is_open = false : set = set_is_open

func _ready():
	hide()
	animation_player.play("RESET")
	card_selector.connect("cards_index_changed", func(): arrow_button_sound.play())
	card_selector.connect("card_selected", _on_card_selected)


func set_is_open(state : bool):
	_is_open = state
	if _is_open:
		jingle_open.play()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
		animation_player.play("appear")
	else:
		jingle_close.play()
		animation_player.play_backwards("appear")
		await animation_player.animation_finished
		if !_is_open and visible: hide()


func _on_card_selected(_card_index : int):
	jingle_select.play()
