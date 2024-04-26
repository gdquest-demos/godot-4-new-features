extends Node2D

enum EXPRESSIONS {DEFAULT, HAPPY, SURPRISED, SAD}

@onready var eye_l = %EyeL
@onready var eye_r = %EyeR
@onready var mouth = %Mouth
@onready var animation_tree = %AnimationTree
@onready var tree_root: AnimationNodeBlendTree = animation_tree.tree_root

func set_expression(expression : EXPRESSIONS):
	var key: String = EXPRESSIONS.find_key(expression).to_lower()
	mouth.set_group(key.capitalize())
	
	if tree_root.has_node("ExpressionTransition"):
		animation_tree.set("parameters/ExpressionTransition/transition_request", key)
