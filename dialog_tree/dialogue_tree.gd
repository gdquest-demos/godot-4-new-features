extends PanelContainer


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

@onready var texture_rect := %TextureRect
@onready var rich_text_label := %RichTextLabel
@onready var buttons_column := %ButtonsColumn
@onready var languages_row := %LanguagesRow
@onready var font_size_label := %FontSizeLabel
@onready var slider := %HSlider


func _ready() -> void:
	_languages_button_group.connect("pressed", set_language)
	slider.connect("value_changed", set_text)
	for button in languages_row.get_children():
		button.button_group = _languages_button_group
	show_line(_line_id)


func show_line(id: int) -> void:
	_line_id = id
	var line_data: Dictionary = _dialogue[id]
	set_text(slider.value)
	set_expression(line_data.expression)
	for button in buttons_column.get_children():
		button.queue_free()
	create_buttons(line_data[_language].buttons)


func set_text(font_size: int) -> void:
	var text: String = _dialogue[_line_id][_language].text
	font_size_label.text = "%s: %03d" % [_font_size_text[_language], font_size]
	rich_text_label.text = "[font_size={0}]{1}[/font_size]".format([font_size, text])


func set_expression(expression: String) -> void:
	if expression == "sad":
		texture_rect.texture = preload("portraits/sophia_sad.png")
	elif expression == "happy":
		texture_rect.texture = preload("portraits/sophia_happy.png")
	else:
		texture_rect.texture = preload("portraits/sophia_neutral.png")


func set_language(_button: Button) -> void:
	_language = _languages_button_group.get_pressed_button().text.to_lower()
	set_text(slider.value)
	for idx in range(buttons_column.get_children().size()):
		buttons_column.get_child(idx).text = _dialogue[_line_id][_language].buttons.keys()[idx]


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button := Button.new()
		button.text = text
		buttons_column.add_child(button)
		var target_line_id = buttons_data[text]
		button.connect("pressed", show_line.bind(target_line_id) if target_line_id >= 0 else get_tree().quit)
