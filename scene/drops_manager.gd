extends Node2D

func get_droppable_of_type(drop_type: Enum.Drop_Type) -> droppable:
	#print("Looking for ", DropUtil.get_drop_type_string(drop_type))
	for d in get_children():
		if d is droppable and d.drop_type == drop_type and d.can_be_picked_up() and !d.is_targeted:
			d.is_targeted = true
			# DELETE THIS IF YOU WANT BETTER PERFORMANCE
			Util.quick_timer(d, 3.0, func():
				if is_instance_valid(d):
					d.is_targeted = false
			)
			return d
	return null

func get_seed_droppable() -> droppable:
	var seeds: Array[Enum.Drop_Type] = []
	for d in get_children():
		if d is droppable and DropUtil.is_seed(d.drop_type) and d.can_be_picked_up():
			return d
	return null
