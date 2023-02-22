@tool
extends EditorScript

#####################################################################

var pouch: Array[Ingredient] = []


var buttons: Array[Button] = [
	Button.new(),
	# uncomment to show error
	#"button",
	#42
]


func create_dialog_options(options_list: Array[String]) -> Array[Button]:
	var buttons_list: Array[Button] = []
	for option in options_list:
		var button := Button.new()
		button.text = option
		buttons_list.append(button)
	return buttons_list

#####################################################################

func add_button() -> void:
	var button := Button.new()
	button.text = "click me"
	buttons.append(button)
	# this does not create any statistical error :(
	# but it will err at runtime
	# buttons.append("hello")

var dialog_lines: Array[String] = []

func add_dialog_line() -> void:
	dialog_lines.append("hello")
	# this does not create any statistical error :(
	# but it will err at runtime
	# dialog_lines.append(12)



func names_to_ingredient(names: Array[String]) -> Array[Ingredient]:
	var arr: Array[Ingredient] = []
	for name in names:
		arr.append(Ingredient.new(name))
	return arr


func is_recipe_available(recipe_name: String, recipe: Array[Ingredient]) -> bool:
	for item in recipe:
		if not pouch.any(func(i): return i.name == item.name):
			print("Cannot cook %s, did not find %s"%[recipe_name, item.name])
			return false
	print("We can cook %s"%[recipe_name])
	return true


func _run() -> void:
	pouch = names_to_ingredient(["thyme", "tomato", "basilic", "olive", "garlic", "oregano"])
	var pizza = names_to_ingredient(["thyme", "tomato", "oregano", "olive"])
	var pasta = names_to_ingredient(["garlic", "tomato", "organo", "olive oil"])
	prints("We have:", ", ".join(pouch))
	is_recipe_available("pizza", pizza)
	is_recipe_available("pasta", pasta)
	add_button()
	print(buttons)
	add_dialog_line()
	print(dialog_lines)
	print(create_dialog_options(dialog_lines))



class Ingredient extends Resource:
	var name := ""

	func _init(initial_name: String) -> void:
		name = initial_name

	func _to_string() -> String:
		return name
