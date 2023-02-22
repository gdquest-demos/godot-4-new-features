class_name ExtendedGroupedProperties extends GroupedProperties


func is_out_of_bounds() -> bool:
	if strength <= 0 or strength >= 10:
		return true
	return false
