extends Node

const PLOT = preload("res://scene/plot.tscn")

func reset_plots():
	if !Globals.PlotGrid:
		return
		
	for c in Globals.PlotGrid.get_children():
		if c is plot:
			c.queue_free()
	
	var plots_left = State.num_plots
	while plots_left > 0:
		Globals.PlotGrid.add_plot()
		plots_left -= 1

func get_total_plots() -> int:
	if !Globals.PlotGrid:
		return 0
	return Globals.PlotGrid.total_plots


func get_plot_for_helper():
	pass
	for c in get_children():
		if !c is plot:
			continue
		#if !c.is_plot_needing_help():
			#continue
		return c
	
func get_random_plot_position() -> Vector2:
	if !Globals.PlotGrid:
		return Vector2.ZERO
	var p = Globals.PlotGrid.get_children().pick_random()
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
