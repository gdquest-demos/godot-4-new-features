extends Node

var _languages_button_group := ButtonGroup.new()
var _line_id := 0
var _language := "en"
var _font_size_text := {
	"en": "Font Size",
	"ro": "Mărimea Font-ului",
}
var _dialogue := [
	{
		"expression": "neutral",
		"en": {
			"text": "Hey, [i]wake up![/i] It's time to make video games.",
			"buttons": {
				"Let me sleep a little longer": 2,
				"Let's do it!": 1,
			},
		},
		"ro": {
			"text": "Hei, [i]trezește-te![/i] A venit timpul pentru a face jocuri video.",
			"buttons": {
				"Lasă-mă să dorm încă puțin": 2,
				"Hai s-o facem!": 1,
			},
		},
	},
	{
		"expression": "neutral",
		"en": {
			"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
			"buttons": {
				"I'm not sure if i'm ready, but i will do my best": 3,
				"No, let me go back to sleep": 2,
			},
		},
		"ro": {
			"text": "Perfect! Prima ta sarcină e să scrii un [b]arbore de dialog[/b].",
			"buttons": {
				"Nu știu dacă sunt gata, dar voi face tot ce pot": 3,
				"Nu, lasă-mă să dorm mai mult": 2,
			},
		},
	},
	{
		"expression": "sad",
		"en": {
			"text": "Oh, come on! It'll be fun.",
			"buttons": {
				"No, really, let me go back to sleep": 0,
				"Alright, I'll try": 3,
			},
		},
		"ro": {
			"text": "Ehh, hai! O să fie distractiv.",
			"buttons": {
				"Nu, chiar așa, lasă-mă să mai dorm": 0,
				"Bine, voi încerca": 3,
			}
		},
	},
	{
		"expression": "happy",
		"en": {
			"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
			"buttons": {"Quit": -1},
		},
		"ro": {
			"text": "Ăsta-i spiritul! Hai că poți!\n[wave][b]AI CÂȘTIGAT[/b][/wave]",
			"buttons": {"Ieși": -1}
		},
	},
]


@onready var speech_bubble = $TopUI/SpeechBubble
@onready var action_buttons := %ActionButtons
@onready var languages_row := %LanguagesRow
@onready var font_size_label := %FontSizeLabel
@onready var slider := %FontSizeSlider


func _ready() -> void:
	_languages_button_group.connect("pressed", set_language)
	slider.connect("value_changed", set_font_size)
	for node in languages_row.get_children():
		if node is Button:
			node.button_group = _languages_button_group
	show_line(_line_id)


func _input(_event):
	var sentences = [
		"Nulla a dui nec orci dictum aliquet.",
		" Suspendisse luctus magna mi, non iaculis neque viverra a.
Integer ut tortor eget neque sagittis pellentesque in sed felis.",
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Curabitur porta, leo et luctus interdum, nisl sapien
pretium lorem, id sagittis tellus nisi eget felis."
	]
	if Input.is_action_just_pressed("ui_accept"):
		var s = sentences.pick_random()
		speech_bubble.write(s)


func show_line(id: int) -> void:
	_line_id = id
	var line_data: Dictionary = _dialogue[id]
	set_text(slider.value)
	for button in action_buttons.get_children():
		button.queue_free()
	create_buttons(line_data[_language].buttons)


func set_font_size(new_size: int) -> void:
	font_size_label.text = "%s: %03d" % [_font_size_text[_language], new_size]
	speech_bubble.set_font_size(new_size)


func set_text(font_size: int) -> void:
	set_font_size(font_size)
	var text: String = _dialogue[_line_id][_language].text
	speech_bubble.write(text)


func set_language(_button: Button) -> void:
	_language = _languages_button_group.get_pressed_button().text.to_lower()
	set_text(slider.value)
	for idx in range(action_buttons.get_children().size()):
		action_buttons.get_child(idx).text = _dialogue[_line_id][_language].buttons.keys()[idx]


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button := Button.new()
		button.text = text
		action_buttons.add_child(button)
		var target_line_id = buttons_data[text]
		button.connect("pressed", show_line.bind(target_line_id) if target_line_id >= 0 else get_tree().quit)
