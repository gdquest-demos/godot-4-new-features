@tool
## Used as a base class for items.
## Demonstrates custom exports and custom resource exports
## Can itself contain items, and so is also the base class for all container
## Check "shield.tres" and "sword.tres" as well as the "custom resources.tscn" scene
## for a demonstration
## This file also serves to illustrate auto-generated documentation
class_name InventoryItem extends Resource


## Used for grouping or quick sorting
enum TYPE{
	WEAPON,
	DEFENSE,
	CONTAINER
}

## Returns the complete title of the item, which is composed of its status name
## and its item name
var full_title := "":
	set(value):
		var name = value.split(" ")
		item_name = name[1]
		status_name = name[0]
	get:
		return status_name + " " + item_name


## How the item looks in an inventory
@export var texture: Texture:
	set(value):
		texture = value
		emit_changed()
## Used when grouping items
@export var item_type: TYPE = TYPE.CONTAINER
## How much is this item worth, when sold
@export_range(0, 100, 1, "suffix:Gils") var price := 5


@export_group("Base", "item_")
## How the item is called. This is used to bundle items together and is case
## sensitive
@export var item_name := "Pouch":
	set(value):
		item_name = value
		emit_changed()
## The item's base weight.
@export var item_weight := 10

@export_group("Special", "status_")
## The status' name. This is free and only used in item labels
@export var status_name := "Magical":
	set(value):
		status_name = value
		emit_changed()
@export var status_list: Array[InventoryStatusEffect]  = []


@export_group("Sub Items")
## If this value is true, then this item can contain other items
@export var is_container := true:
	set(value):
		is_container = value
		if not is_container:
			maximum_countenance = 0
		else:
			maximum_countenance = max(maximum_countenance, 1)
## How many items can this item contain. If the maximum countenance
@export var maximum_countenance := 10
## An array of items.
@export var contents: Array[InventoryItem] = []:
	set(value):
		value.resize(maximum_countenance)
		contents = value


## If this item can contain other items, those item's weight will be added to
## the total weight
var total_weight := 0:
	get:
		return contents.reduce(
			func(acc: int, item: InventoryItem):
				return item.total_weight + acc
		, item_weight
		)


## Total item's value, as well as its contents' value
func get_total_price() -> int:
	return contents.reduce(
		func(acc: int, item: InventoryItem):
			return item.get_total_price() + acc
	, price
	)
	
