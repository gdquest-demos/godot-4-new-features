extends HBoxContainer

@export var card_scene : PackedScene

@onready var grid = %Grid
@onready var left_arrow = %LeftArrow
@onready var right_arrow = %RightArrow

var cards_count = 14
var max_displayed_cards = 8
# Index of displayed card group
var current_index = 0
var max_index = floor(float(cards_count) / max_displayed_cards)

var active_card_index = -1 : set = _set_active_card_index

signal cards_index_changed
signal card_selected(index : int)

func _ready():
	# fill menu with empty cards
	for i in range(cards_count):
		var card = card_scene.instantiate()
		grid.add_child(card)
		card.set_title("Demo " + str(i + 1))
		card.focused = false
		card.connect("pressed", _set_active_card_index.bind(i))
		if i >= max_displayed_cards: card.hide()
	# Connect arrows for navigation
	left_arrow.connect("pressed", _incr_current_index.bind(-1))
	right_arrow.connect("pressed", _incr_current_index.bind(1))
	_check_arrow()
	active_card_index = 0

func _set_active_card_index(card_index : int):
	if active_card_index == card_index: return
	grid.get_child(active_card_index).active = false
	grid.get_child(card_index).active = true
	active_card_index = card_index
	emit_signal("card_selected", card_index)
	
func _incr_current_index(incr : int):
	var next_index = clamp(current_index + incr, 0, max_index)
	if next_index == current_index: return
	
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
	
	emit_signal("cards_index_changed")
	
func _check_arrow():
	left_arrow.disabled = false
	right_arrow.disabled = false
	
	if current_index == 0:
		left_arrow.disabled = true
		
	if current_index == max_index:
		right_arrow.disabled = true
	
func _get_cards(at_index : float = 0):
	var start = at_index * max_displayed_cards
	var end = clamp(start + max_displayed_cards, 0, cards_count)
	
	return grid.get_children().filter(func(card):
		var card_index = card.get_index()
		return card_index in range(start, end))
	
