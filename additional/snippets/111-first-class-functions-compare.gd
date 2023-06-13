extends Node


func _compare_property(a, b, property: String) -> bool:
	if property in a and property in b:
		return a[property] > b[property]
	else:
		return property in a

var items = [
	{"name": "Potion", "weight": 3},
	{"name": "Coin", "weight": 1},
]

func sort_inventory():
	# Callable that sorts items using their weight property.
	var sort_by_weight := _compare_property.bind("weight")
	# We can pass the Callable to the the Array.sort_custom() function to use it for sorting.
	items.sort_custom(sort_by_weight)
	print(items)
