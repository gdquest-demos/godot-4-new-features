extends HBoxContainer

const Card := preload("res://main/menu_scene_selector/card/card.gd")
const CardScene := preload("res://main/menu_scene_selector/card/card.tscn")


@onready var grid = %Grid
@onready var left_arrow = %LeftArrow
@onready var right_arrow = %RightArrow

var max_displayed_cards = 8
# Index of displayed card group
var current_index = 0
var max_index = 0

var active_card_index = 0 : set = _set_active_card_index

signal cards_index_changed
signal card_selected(index : int)


func _ready():
	left_arrow.pressed.connect(_incr_current_index.bind(-1))
	right_arrow.pressed.connect(_incr_current_index.bind(1))


func focus_current_card() -> void:
	grid.get_child(active_card_index).grab_focus()


func create_card(card_title: String, thumbnail : Texture2D, description: String) -> void:
	var card: Card = CardScene.instantiate()
	grid.add_child(card)
	card.set_title(card_title)
	card.set_thumbnail(thumbnail)
	card.set_description(description)
	card.focused = false
	var card_index = grid.get_child_count() - 1
	card.pressed.connect(_set_active_card_index.bind(card_index))
	if card_index >= max_displayed_cards:
		card.hide()
	
	max_index = floor(float(grid.get_child_count()) / max_displayed_cards)
	_check_arrow()


func _set_active_card_index(card_index : int):
	var previous_card: Card  = grid.get_child(active_card_index) as Card
	previous_card.active = false
	active_card_index = card_index
	var current_card: Card  = grid.get_child(active_card_index) as Card
	current_card.active = true
	current_card.hint_text.popout(true)
	card_selected.emit(card_index)


func _incr_current_index(incr : int):
	var next_index = clamp(current_index + incr, 0, max_index)
	if next_index == current_index:
		return
	
	var current_cards = _get_cards(current_index)
	
	var t = create_tween()
	t.tween_property(grid, "modulate:a", 0.0, 0.15)
	await t.finished
	
	for card in current_cards:
		card.hide()
	
	var next_cards = _get_cards(next_index)
	for card in next_cards:
		card.show()
		
	t = create_tween()
	t.tween_property(grid, "modulate:a", 1.0, 0.15)
		
	current_index = next_index
	_check_arrow()
	
	cards_index_changed.emit()

	if incr > 0:
		grid.get_child(current_index * max_displayed_cards).grab_focus()
	else:
		grid.get_child((current_index + 1) * max_displayed_cards - 1).grab_focus()

func _check_arrow():
	left_arrow.disabled = false
	right_arrow.disabled = false
	
	if current_index == 0:
		left_arrow.disabled = true
		
	if current_index == max_index:
		right_arrow.disabled = true


func _get_cards(at_index : float = 0):
	var start = at_index * max_displayed_cards
	var end = clamp(start + max_displayed_cards, 0, grid.get_child_count())
	
	return grid.get_children().filter(func(card):
		var card_index = card.get_index()
		return card_index in range(start, end))
	
