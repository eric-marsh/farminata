extends Node2D

func get_droppable_of_type(drop_type: Enum.Drop_Type) -> droppable:
	print("Looking for ", DropUtil.get_drop_type_string(drop_type))
	for d in get_children():
		if d is droppable and d.drop_type == drop_type and !d.is_held and !d.is_delivered:
			return d
	return null
