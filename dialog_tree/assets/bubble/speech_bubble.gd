extends Control


@onready var panel = $Panel
@onready var margin = $Margin
@onready var rich_text_label = $Margin/RichTextLabel
@onready var tail = $Tail

@onready var audio_stream_player = $AudioStreamPlayer


var _is_open = false
var _text_tween : Tween = null
var _last_pos = -1

signal vowel
signal speech_end


func _ready():
	margin.connect("resized", _on_resized)
	scale = Vector2.ZERO
	modulate.a = 0.0


func write(text : String):
	if not _is_open:
		open()
	audio_stream_player.play()

	rich_text_label.text = text
	if _text_tween != null and _text_tween.is_valid():
		_text_tween.kill()

	_last_pos = -1

	_text_tween = create_tween()
	_text_tween.tween_method(_tween_text, 0.0, 1.0, text.length() / 30.0)
	_text_tween.tween_callback(emit_signal.bind("speech_end"))


func set_font_size(new_size: int) -> void:
	rich_text_label.text = "[font_size={0}]{1}[/font_size]".format([new_size, rich_text_label.get_parsed_text()])


func _tween_text(progress):
	rich_text_label.visible_ratio = progress
	var text_length = rich_text_label.text.length()
	var pos = floor(text_length * progress)
	if pos == _last_pos: return
	var letter = rich_text_label.text.substr(pos, 1)
	if ["a","e","i","o","u"].has(letter):
		emit_signal("vowel")
	_last_pos = pos

func open():
	_is_open = true
	var open_tween = create_tween().set_parallel(true)
	open_tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	open_tween.tween_property(self, "modulate:a", 1.0, 0.1)

func close():
	_is_open = false
	var close_tween = create_tween().set_parallel(true)
	close_tween.tween_property(self, "scale", Vector2.ONE * 0.8, 0.1)
	close_tween.tween_property(self, "modulate:a", 0.0, 0.1)

func _on_resized():
	var half_size = (margin.size / 2.0)
	margin.pivot_offset = half_size
	panel.pivot_offset = half_size
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(panel, "custom_minimum_size", margin.size, 0.2)

	tail.polygon[0].y = half_size.y
	tail.polygon[1].y = half_size.y
	tail.polygon[2].y = half_size.y + 128.0

	var tail_width = margin.size.x * 0.1

	tail.polygon[0].x = -tail_width
	tail.polygon[1].x = tail_width
	tail.polygon[2].x = -tail_width
