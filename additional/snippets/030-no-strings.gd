


func has_higher_value(a: Item, b: Item) -> bool:
	return a.price > b.price



func sort_by_value(inventory: Array[Item]) -> void:
	inventory.sort_custom(has_higher_value)



















#####################################################################



func _run() -> void:
	var inventory = create_items(["sword", "shield", "potion", "pelt", "boots"])
	print(inventory)
	sort_by_value(inventory)
	print(inventory)


func create_items(names:Array[String]) -> Array[Item]:
	var name_to_item := func (name: String) -> Item:
		return Item.new(name, randi_range(1, 10))
	var array: Array[Item] = []
	array.assign(names.map(name_to_item))
	return array


class Item extends Resource:
	var name := ""
	var price := 10

	func _init(initial_name: String, initial_price: int) -> void:
		name = initial_name
		price = initial_price
	
	func _to_string() -> String:
		return "(%s:$%s)"%[name, price]
	
