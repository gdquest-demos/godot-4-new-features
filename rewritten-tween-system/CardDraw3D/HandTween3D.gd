extends Spatial

# Maximum rotation we apply to cards on the edges of the hand.
const CARD_ROTATION := deg2rad(15.0)
# Horizontal spread of the hands on the Z axis.
const HAND_SPREAD := 5.0
# Offset applied to each card towards the camera to render them in the correct
# order.
const HEIGHT_DIFFERENCE := 0.02

export(PackedScene) var card_scene

export var minimum_hand_size := 2
export var maximum_hand_size := 6
# We place cards along this curve.
export var height_curve: Curve
# This curve controls the amount of rotation applied to each card.
export var rotation_curve: Curve

onready var hand: Spatial = $Player/Hand
onready var deck: Area = $Player/Deck
onready var cards_resting_place: Area = $Player/CardsRestingPlace


func _ready() -> void:
	deck.connect("clicked", self, "_create_and_animate_cards")
	cards_resting_place.connect("area_entered", self, "_on_CardsRestingPlace_area_entered")



func _create_and_animate_cards() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	if not hand.get_children().empty():
		for child in hand.get_children():
			tween.tween_property(child, "translation", cards_resting_place.translation, 1)

	var card_count := int(rand_range(1, 5))
	for child_index in card_count + 1:
		# Create a new card instance
		var new_card: Card3D = card_scene.instance()
		new_card.card_art = preload("res://assets/blackhole.png")
		new_card.card_name = "Black Hole"
		new_card.translation = deck.translation
		new_card.scale = Vector3.ZERO
		new_card.translation.z -= 1
		hand.add_child(new_card)

		# Calculate the card's position, rotation, and scale in hand
		var ratio_in_hand := float(child_index) / card_count
		var target_translation := Vector3(
			height_curve.interpolate(ratio_in_hand) * 2.0,
			child_index * HEIGHT_DIFFERENCE,
			-(HAND_SPREAD * card_count * 0.5) + child_index * HAND_SPREAD
		)
		var target_angle := -PI / 2.0 + rotation_curve.interpolate(ratio_in_hand) * CARD_ROTATION
		var basis := Basis(Vector3.UP, target_angle).scaled(Vector3.ONE * 2.0)
		var target_transform := Transform(basis, target_translation)

		tween.tween_property(new_card, "scale", Vector3.ONE * 0.8, 0.2)
		tween.parallel().tween_property(new_card, "translation:x", new_card.translation.x + 3.0, 0.3).set_trans(Tween.TRANS_BACK)
		tween.tween_property(new_card, "transform", target_transform, 0.5)


func _on_CardsRestingPlace_area_entered(card: Node) -> void:
	card.queue_free()
