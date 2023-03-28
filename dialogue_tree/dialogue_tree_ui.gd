extends Node


@export_enum("en", "ro", "ja", "ar") var language := "en"

var _languages_button_group := ButtonGroup.new()
var _line_id := 0
var _font_size_text := {
	"en": "Font Size",
	"ro": "Mărimea Font-ului",
	"ja": "文字サイズ",
	"ar": "حجم الخط",
}

var _language_text := {
	"en": "Language",
	"ro": "Limba",
	"ja": "言語",
	"ar": "اللغة",
}

var _dialogue := [
	{
		"expression": "neutral",
		"en": {
			"text": "[i]Hey, wake up![/i]\nIt's time to make video games.",
			"buttons": {
				"Let me sleep a little longer": 2,
				"Let's do it!": 1,
			},
		},
		"ro": {
			"text": "[i]Hei, trezește-te![/i]\nA venit timpul pentru a face jocuri video.",
			"buttons": {
				"Lasă-mă să dorm încă puțin": 2,
				"Hai s-o facem!": 1,
			},
		},
		"ja": {
			"text": "[i]ねえ、もう起きて！[/i]\nゲームを作る時間だよ。",
			"buttons": {
				"もう少し寝かせて": 2,
				"オッケー、やりましょう！": 1,
			},
		},
		"ar": {
			"text": "هيه استيقظ! حان الوقت لكي تصنع ألعاب الفيديو",
			"buttons": {
				"دعيني انام بعض القليل": 2,
				"هيا بنا!": 1,
			},
		}
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
		"ja": {
			"text": "よし！最初のタスクは対話システムを開発する。",
			"buttons": {
				"できるかどうかわからないけど頑張るよ": 3,
				"やっぱりもうちょっと寝たいよ": 2,
			},
		},
		"ar": {
			"text": "ممتاز! مهمتك الأولى هي برمجة [b]شجرة حوار[/b]",
			"buttons": {
				"لست متأكدا انني مستعد، لكنني سأبذل جهدي": 3,
				"لا، دعيني أعود للنوم": 2,
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
		"ja": {
			"text": "ほら、楽しくなるよ。",
			"buttons": {
				"嫌だ！寝たいよ": 0,
				"よし、やってみよう": 3,
			},
		},
		"ar": {
			"text": "هيه! سيكون الأمر ممتعًا.",
			"buttons": {
				"لا، بحقك، دعيني أعود للنوم": 0,
				"حسنًا، سأحاول": 3,
			},
		},
	},
	{
		"expression": "happy",
		"en": {
			"text": "That's the spirit! [wave]You can do it![/wave]",
			"buttons": {"Quit": -1},
		},
		"ro": {
			"text": "Ăsta-i spiritul! [wave]Hai că poți![/wave]",
			"buttons": {"Ieși": -1}
		},
		"ja": {
			"text": "その意気だ！[wave]君ならできるよ！[/wave]",
			"buttons": {"終了": -1,},
		},
		"ar": {
			"text": "احسنت! [wave]انت قادر على ذلك![/wave]",
			"buttons": {"إنهاء": -1},
		},
	},
]

@onready var speech_bubble: Control = %SpeechBubble
@onready var action_buttons: VBoxContainer = %ActionButtons
@onready var languages_row: HBoxContainer = %LanguagesRow
@onready var language_label: Label = %LanguageLabel
@onready var font_size_label: Label = %FontSizeLabel
@onready var slider: HSlider = %FontSizeSlider
@onready var pink_hair_character: Node2D = %PinkHairCharacter
@export var round_button_scene : PackedScene


func _ready() -> void:
	_languages_button_group.pressed.connect(set_language)
	slider.value_changed.connect(set_font_size)
	
	speech_bubble.vowel_appeared.connect(pink_hair_character.random_mouth)
	speech_bubble.speech_ended.connect(pink_hair_character.reset_mouth)
	
	for node in languages_row.get_children():
		if node is Button:
			node.button_group = _languages_button_group
			node.button_pressed = node.text.to_lower() == language
	show_line(_line_id)


func show_line(id: int) -> void:
	_line_id = id
	var line_data: Dictionary = _dialogue[id]
	set_text(int(slider.value))
	for button in action_buttons.get_children():
		button.destroy()
	await speech_bubble.speech_ended
	create_buttons(line_data[language].buttons)


func set_font_size(new_size: int) -> void:
	font_size_label.text = "%s" % [_font_size_text[language]]
	speech_bubble.set_font_size(new_size)


func set_text(font_size: int) -> void:
	set_font_size(font_size)
	language_label.text = _language_text[language]
	var text: String = _dialogue[_line_id][language].text
	speech_bubble.write(text)


func set_language(_button: Button) -> void:
	language = _languages_button_group.get_pressed_button().text.to_lower()
	set_text(int(slider.value))
	for idx in range(action_buttons.get_children().size()):
		action_buttons.get_child(idx).text = _dialogue[_line_id][language].buttons.keys()[idx]


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button : Button = round_button_scene.instantiate()
		button.text = text
		action_buttons.add_child(button)
		var target_line_id: int = buttons_data[text]
		button.connect("pressed", show_line.bind(target_line_id) if target_line_id >= 0 else get_tree().quit)
