extends Node

const PLOT = preload("res://scene/plot.tscn")


func add_plot():
	if !Globals.PlotsContainer or !Globals.EnviornmentLayers or Globals.PlotsContainer.remaining_plot_points.size() == 0:
		return
		
	var p = PLOT.instantiate() as plot
	p.global_position = get_random_position_in_grow_area()
	if Debug.ALL_FULL_CROPS_AT_START:
		p.plot_growth_state = Enum.Plot_Growth_State.Full
		p.grow_type = Enum.Grow_Type.Carrot
		p.update_image()
	
	Globals.PlotsContainer.add_child(p)
	State.num_plots += 1
	Globals.EnviornmentLayers.update_enviornment_layer()
	

var num_rows = 8
var num_cols = 12
func reset_plots():
	if !Globals.PlotsContainer:
		return
	
	if !Debug.KEEP_PLOTS_ON_START:	
		for c in Globals.PlotsContainer.get_children():
			c.queue_free()
		
	
	# figure out the positions
	var width: float = Globals.GrowArea.get_node("CollisionShape2D").shape.extents.x * 2 
	var height: float = Globals.GrowArea.get_node("CollisionShape2D").shape.extents.y * 2 
	Globals.PlotsContainer.remaining_plot_points.clear()
	for i in range(num_cols):
		for j in range(num_rows):
			Globals.PlotsContainer.remaining_plot_points.push_back( Vector2((width/num_cols) * i, (height/num_rows) * j)  )
	Globals.PlotsContainer.remaining_plot_points.shuffle()
	
	# add the plots
	await get_tree().create_timer(0.1).timeout
	var plots_left = State.num_plots - get_total_plots()
	while plots_left > 0:
		add_plot()
		plots_left -= 1
	State.num_plots = get_total_plots()

func get_random_position_in_grow_area() -> Vector2:
	if !Globals.PlotsContainer or Globals.PlotsContainer.remaining_plot_points.is_empty():
		return Vector2.ZERO
	
	var pos: Vector2 = Globals.PlotsContainer.remaining_plot_points[0]
	Globals.PlotsContainer.remaining_plot_points = Globals.PlotsContainer.remaining_plot_points.slice(1)

	var shape = Globals.GrowArea.get_node("CollisionShape2D").shape
	var top_left = Globals.GrowArea.global_position - shape.extents  # Actual top-left of area
	
	return top_left + pos + Util.random_offset(8) + Vector2(0, 32)
	

func get_total_plots() -> int:
	if !Globals.PlotsContainer:
		return 0
	return Globals.PlotsContainer.get_children().size()

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
	return p.global_position

func does_plot_need_seed(p: plot) -> bool:
	return p.plot_growth_state == Enum.Plot_Growth_State.None

func get_plot_that_needs_seed(target_pos: Vector2 = Vector2.ZERO) -> plot:
	var current_closest_plot: plot = null
	var current_closest_distance: float = 999999
	for c in Globals.PlotsContainer.get_children():
		if !c is plot:
			continue
		if does_plot_need_seed(c):
			if target_pos == Vector2.ZERO:
				# not checking for closest plot. Just return first plot found
				return c
			var dist: float = c.global_position.distance_to(target_pos)
			if !current_closest_plot or dist < current_closest_distance:
				if current_closest_distance <= 128:
					return c
				current_closest_plot = c
				current_closest_distance = dist
	return current_closest_plot

func does_plot_need_water(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Dry and p.plot_growth_state != Enum.Plot_Growth_State.Full

func get_plot_that_needs_water(target_pos: Vector2 = Vector2.ZERO) -> plot:
	var current_closest_plot: plot = null
	var current_closest_distance: float = 999999
	for c in Globals.PlotsContainer.get_children():
		if !c is plot:
			continue
		if does_plot_need_water(c):
			if target_pos == Vector2.ZERO:
				# not checking for closest plot. Just return first plot found
				return c
			var dist: float = c.global_position.distance_to(target_pos)
			if !current_closest_plot or dist < current_closest_distance:
				if current_closest_distance <= 128:
					return c
				current_closest_plot = c
				current_closest_distance = dist
			
	return current_closest_plot

func does_plot_need_sun(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Wet and p.plot_growth_state != Enum.Plot_Growth_State.None

func get_plot_that_needs_sun(target_pos: Vector2 = Vector2.ZERO) -> plot:
	var current_closest_plot: plot = null
	var current_closest_distance: float = 999999
	for c in Globals.PlotsContainer.get_children():
		if !c is plot:
			continue
		if does_plot_need_sun(c):
			if target_pos == Vector2.ZERO:
				# not checking for closest plot. Just return first plot found
				return c
			var dist: float = c.global_position.distance_to(target_pos)
			if !current_closest_plot or dist < current_closest_distance:
				if current_closest_distance <= 128:
					return c
				current_closest_plot = c
				current_closest_distance = dist
			
	return current_closest_plot

func does_plot_need_plucking(p: plot) -> bool:
	return p.plot_growth_state == Enum.Plot_Growth_State.Full

func get_plot_that_needs_plucking(target_pos: Vector2 = Vector2.ZERO) -> plot:
	var current_closest_plot: plot = null
	var current_closest_distance: float = 999999
	for c in Globals.PlotsContainer.get_children():
		if !c is plot:
			continue
		if does_plot_need_plucking(c):
			if target_pos == Vector2.ZERO:
				# not checking for closest plot. Just return first plot found
				return c
			var dist: float = c.global_position.distance_to(target_pos)
			if !current_closest_plot or dist < current_closest_distance:
				if current_closest_distance <= 128:
					return c
				current_closest_plot = c
				current_closest_distance = dist
				
			
	return current_closest_plot

func find_plot_for_droppable(d: droppable, pos: Vector2):
	if DropUtil.is_seed(d.drop_type):
		return get_plot_that_needs_seed(pos)
	if d.drop_type == Enum.Drop_Type.Water:
		return get_plot_that_needs_water(pos)
	if d.drop_type == Enum.Drop_Type.Sun:
		return get_plot_that_needs_sun(pos)
	return null

func does_plot_need_droppable(d: droppable, p: plot) -> bool:
	if DropUtil.is_seed(d.drop_type):
		return does_plot_need_seed(p)
	if d.drop_type == Enum.Drop_Type.Water:
		return does_plot_need_water(p)
	if d.drop_type == Enum.Drop_Type.Sun:
		return does_plot_need_sun(p)
	return false
