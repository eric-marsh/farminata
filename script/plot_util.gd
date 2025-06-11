extends Node

const PLOT = preload("res://scene/plot.tscn")


func add_plot(pos: Vector2):
	var p = PLOT.instantiate() as plot
	p.global_position = pos
	add_child(p)
	

func reset_plots():
	if !Globals.PlotsContainer:
		return
	
	if !Debug.KEEP_PLOTS_ON_START:	
		for c in Globals.PlotsContainer.get_children():
			if c is plot:
				c.queue_free()
	
	var plots_left = State.num_plots - get_total_plots()
	while plots_left > 0:
		add_plot(get_random_position_in_grow_area())
		plots_left -= 1

func get_total_plots() -> int:
	if !Globals.PlotsContainer:
		return 0
	return Globals.PlotsContainer.get_children().size()

func get_random_position_in_grow_area() -> Vector2:
	var collision_shape = Globals.GrowArea.get_node("CollisionShape2D")
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var local_pos = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		return collision_shape.global_position + local_pos
	return collision_shape.global_position



func get_plot_for_helper():
	pass
	for c in get_children():
		if !c is plot:
			continue
		#if !c.is_plot_needing_help():
			#continue
		return c
	
func get_random_plot_position() -> Vector2:
	if !Globals.PlotsContainer:
		return Vector2.ZERO
	var p = Globals.PlotsContainer.get_children().pick_random()
	return p.global_position + p.size / 2

func does_plot_need_seed(p: plot) -> bool:
	return p.plot_growth_state == Enum.Plot_Growth_State.None

func get_plot_that_needs_seed() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if does_plot_need_seed(c):
			return c
	return null

func does_plot_need_water(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Dry and p.plot_growth_state != Enum.Plot_Growth_State.Full

func get_plot_that_needs_water() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if does_plot_need_water(c):
			return c
	return null

func does_plot_need_sun(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Wet and p.plot_growth_state != Enum.Plot_Growth_State.None

func get_plot_that_needs_sun() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if does_plot_need_sun(c):
			return c
	return null

func does_plot_need_plucking(p: plot) -> bool:
	return p.plot_growth_state == Enum.Plot_Growth_State.Full

func get_plot_that_needs_plucking() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if does_plot_need_plucking(c):
			return c
	return null

func find_plot_for_droppable(d: droppable):
	if DropUtil.is_seed(d.drop_type):
		return get_plot_that_needs_seed()
	if d.drop_type == Enum.Drop_Type.Water:
		return get_plot_that_needs_water()
	if d.drop_type == Enum.Drop_Type.Sun:
		return get_plot_that_needs_sun()
	return null

func does_plot_need_droppable(d: droppable, p: plot) -> bool:
	if DropUtil.is_seed(d.drop_type):
		return does_plot_need_seed(p)
	if d.drop_type == Enum.Drop_Type.Water:
		return does_plot_need_water(p)
	if d.drop_type == Enum.Drop_Type.Sun:
		return does_plot_need_sun(p)
	return false
