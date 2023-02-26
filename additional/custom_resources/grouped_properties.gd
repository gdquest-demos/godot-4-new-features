## Demonstrates how to create groups of exports
## open the file "grouped_properties_example.tres
class_name GroupedProperties extends Resource

enum ELEMENT{ FIRE, WATER, EARTH, WIND }

@export var name = "Vampire"

@export_group("Basic Properties")
@export var hit_points = 100
@export var type: ELEMENT = ELEMENT.FIRE

@export_subgroup("Combat Properties", "strength_")
@export var strength_blunt := 5.0
@export var strength_sharp := 7.0
@export var strength_pierce := 15.0


@export_group("Bat Children")
@export var has_bats := false
@export_range(1, 100, 1) var bats_speed := 10.0
@export_range(0.1, 5, 0.1, "suffix:seconds") var bats_timeout := 1.5

@export_group("Region", "region_")
@export var region_enabled := false
@export var region_rectangle := Rect2()

var strength := 0


func is_out_of_bounds() -> bool:
	return false





