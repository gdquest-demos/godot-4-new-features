extends Control

signal vowel_appeared
signal speech_ended

@onready var panel: Panel = %Panel
@onready var margin: MarginContainer = %Margin
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var tail: Polygon2D = %Tail
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


var _is_open := false
var _text_tween : Tween = null
var _last_pos := -1


func _ready() -> void:
	margin.connect("resized", _resize_bubble_tail)
	scale = Vector2.ZERO
	modulate.a = 0.0


func write(text : String) -> void:
	if not _is_open:
		open()
	audio_stream_player.play()

	rich_text_label.text = text
	if _text_tween != null and _text_tween.is_valid():
		_text_tween.kill()

	_last_pos = -1

	_text_tween = create_tween()
	_text_tween.tween_method(_tween_text, 0.0, 1.0, text.length() / 30.0)
	_text_tween.tween_callback(emit_signal.bind("speech_ended"))


func set_font_size(new_size: int) -> void:
	const font_size_properties := [
		"normal_font_size",
		"bold_font_size",
		"italics_font_size",
		"bold_italics_font_size",
	]
	for property in font_size_properties:
		rich_text_label.add_theme_font_size_override(property, new_size)


func _tween_text(progress: float) -> void:
	rich_text_label.visible_ratio = progress
	var text_length := rich_text_label.text.length()
	var pos: int = floor(text_length * progress)
	if pos == _last_pos: return
	var letter := rich_text_label.text.substr(pos, 1)
	if ["a","e","i","o","u","ا","ي","و"].has(letter):
		emit_signal("vowel_appeared")
	_last_pos = pos


func open() -> void:
	_is_open = true
	var open_tween := create_tween().set_parallel(true)
	open_tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	open_tween.tween_property(self, "modulate:a", 1.0, 0.1)


func close() -> void:
	_is_open = false
	var close_tween := create_tween().set_parallel(true)
	close_tween.tween_property(self, "scale", Vector2.ONE * 0.8, 0.1)
	close_tween.tween_property(self, "modulate:a", 0.0, 0.1)


func _resize_bubble_tail() -> void:
	var half_size := (margin.size / 2.0)
	margin.pivot_offset = half_size
	panel.pivot_offset = half_size
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(panel, "custom_minimum_size", margin.size, 0.2)

	tail.polygon[0].y = half_size.y
	tail.polygon[1].y = half_size.y
	tail.polygon[2].y = half_size.y + margin.size.y * 0.8

	var tail_width := margin.size.x * 0.05

	tail.polygon[0].x = -tail_width
	tail.polygon[1].x = tail_width
	tail.polygon[2].x = -tail_width
