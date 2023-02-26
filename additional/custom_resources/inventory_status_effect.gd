## A status effect for the items
## It's extended to verify that all the subclasses do show
## in the inspector
class_name InventoryStatusEffect extends Resource

var expression := Expression.new()


@export var name := ""
@export var effect := "":
	set(value):
		effect = value
		var error := expression.parse(effect, ["item"])
		if error != OK:
			#print(expression.get_error_text())
			return


func execute(item: InventoryItem) -> void:
	expression.execute([item])
