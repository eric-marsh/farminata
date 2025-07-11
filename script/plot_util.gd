extends Node

const PLOT = preload("res://scene/plot.tscn")

func add_plot():
	if !Globals.PlotsContainer or !Globals.EnviornmentLayers or Globals.PlotsContainer.remaining_plot_points.size() == 0:
		return
		
	var p = PLOT.instantiate() as plot
	p.global_position = get_random_position_in_grow_area()
	
	
	Globals.PlotsContainer.add_child(p)
	if Debug.ALL_RANDOM_CROPS_AT_START:
		p.plot_growth_state = [Enum.Plot_Growth_State.Full, Enum.Plot_Growth_State.Seed, Enum.Plot_Growth_State.Partial_1, Enum.Plot_Growth_State.Partial_2].pick_random()
		var grow_type = State.unlocked_slot_outputs.pick_random()
		p.grow_type = PlantUtil.drop_type_to_grow_type(grow_type if grow_type else Enum.Grow_Type.Carrot)
		p.update_image()
	
	if Debug.ALL_FULL_CROPS_AT_START:
		p.plot_growth_state = Enum.Plot_Growth_State.Full
		var grow_type = State.unlocked_slot_outputs.pick_random()
		p.grow_type = PlantUtil.drop_type_to_grow_type(grow_type if grow_type else Enum.Grow_Type.Carrot)
		p.update_image()
	State.num_plots += 1
	Globals.EnviornmentLayers.update_enviornment_layer()
	for pi in Globals.PiniataContainer.get_children():
		pi.plot_message.visible = false
		pi.num_failed_drops_in_a_row = 0


var num_rows = 10
var num_cols = State.max_plots / 10


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
			var pos: Vector2 = Vector2((width/num_cols) * i, (height/num_rows) * j) 
			if pos.distance_to(Vector2(320, 220)) < 4:
				continue
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
	if !Globals.PlotsContainer or Globals.PlotsContainer.remaining_plot_points.is_empty() or Globals.PlotsContainer.get_children().size() == 0:
		return Vector2(320, 220)
		
	var shape = Globals.GrowArea.get_node("CollisionShape2D").shape
	var top_left = Globals.GrowArea.global_position - shape.extents  # Actual top-left of area
	
	var result_pos: Vector2
	var max_distance = 100
	
	var i:int = 0
	if State.num_plots <= 10:
		max_distance = 100
		for pos in Globals.PlotsContainer.remaining_plot_points:
			var dist: float = (Vector2(320, 220)).distance_to(pos)
			if dist < max_distance:
				result_pos = pos
				break
			i += 1
		if !result_pos:
			max_distance = 300
			i = 0
			for pos in Globals.PlotsContainer.remaining_plot_points:
				var dist: float = (Vector2(320, 220)).distance_to(pos)
				if dist < max_distance:
					result_pos = pos
					break
				i += 1
	else:
		max_distance = 650
		var last_plot_position = Globals.PlotsContainer.get_children()[Globals.PlotsContainer.get_children().size() - 1].global_position
		for pos in Globals.PlotsContainer.remaining_plot_points:
			var dist: float = last_plot_position.distance_to(pos)
			if dist < max_distance and dist > 8:
				result_pos = pos
				break
			i += 1
	
	if !result_pos:
		print("COULDNT FIND POS")
		result_pos =  Globals.PlotsContainer.remaining_plot_points.pick_random()
	else:
		Globals.PlotsContainer.remaining_plot_points.remove_at(i)

	
	return top_left + result_pos + Util.random_offset(8) + Vector2(0, 26)


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

func does_plot_need_water(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Dry and p.plot_growth_state != Enum.Plot_Growth_State.Full

func does_plot_need_sun(p: plot) -> bool:
	return p.plot_state == Enum.Plot_State.Wet and p.plot_growth_state != Enum.Plot_Growth_State.None

func does_plot_need_plucking(p: plot) -> bool:
	return p.plot_growth_state == Enum.Plot_Growth_State.Full

func get_plot_needing_condition(condition_func: Callable, target_pos: Vector2 = Vector2.ZERO) -> plot:
	var closest_plot: plot = null
	var closest_distance := 999999.0

	for c in Globals.PlotsContainer.get_children():
		if !c is plot or c.target_helper != null:
			continue
		if condition_func.call(c):
			if target_pos == Vector2.ZERO:
				return c
			
			var dist = c.global_position.distance_to(target_pos)
			if !closest_plot or dist < closest_distance:
				if dist <= 32:
					return c
				closest_plot = c
				closest_distance = dist
	return closest_plot

func get_plot_that_needs_seed(target_pos: Vector2 = Vector2.ZERO) -> plot:
	return get_plot_needing_condition(does_plot_need_seed, target_pos)

func get_plot_that_needs_water(target_pos: Vector2 = Vector2.ZERO) -> plot:
	return get_plot_needing_condition(does_plot_need_water, target_pos)

func get_plot_that_needs_sun(target_pos: Vector2 = Vector2.ZERO) -> plot:
	return get_plot_needing_condition(does_plot_need_sun, target_pos)

func get_plot_that_needs_plucking(target_pos: Vector2 = Vector2.ZERO) -> plot:
	return get_plot_needing_condition(does_plot_need_plucking, target_pos)

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
