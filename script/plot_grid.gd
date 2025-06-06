extends Node2D
class_name plot_grid

var num_plots = State.num_plots

var plots: Array[plot] = []
func _ready() -> void:
	reset_plots()
	
	if Debug.ALL_FULL_CROPS_AT_START:
		for p in plots:
			p.plot_growth_state = Enum.Plot_Growth_State.Full
			p.grow_type = Enum.Grow_Type.Carrot
			p.update_image()
	
func _process(_delta: float) -> void:
	pass

const PLOT = preload("res://scene/plot.tscn")
func reset_plots():
	plots.clear()
			
	for c in get_children():
		if c is plot:
			c.queue_free()
	
	var plots_left = num_plots
	while plots_left > 0:
		add_plot()
		plots_left -= 1


func add_plot():
	var p = PLOT.instantiate() as plot
	var square_pos = get_square_position(get_total_plots())
	p.position = square_pos * p.size
	add_child(p)
	plots.push_back(p)
	
	var tile_map_layer = $TileMapLayer as TileMapLayer
	var source_id: int = 2
	var terrain_set: int = 0
	tile_map_layer.set_cell(square_pos, source_id, Vector2i(1, 1), 0)
	tile_map_layer.set_cells_terrain_connect([square_pos], terrain_set, terrain_set)
	
	update_push_zone(p.size.x)


func get_total_plots() -> int:
	return plots.size()

func get_square_position(index: int) -> Vector2:
	return square_position_array[index] if square_position_array.size() > index else Vector2.ZERO

func get_plot_for_helper():
	pass
	for c in get_children():
		if !c is plot:
			continue
		#if !c.is_plot_needing_help():
			#continue
		return c
	
func get_random_plot_position() -> Vector2:
	var p = plots.pick_random()
	return p.global_position + p.size / 2



func get_plot_that_needs_seed() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if c.plot_growth_state == Enum.Plot_Growth_State.None:
			return c
	return null

func get_plot_that_needs_water() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if c.plot_state == Enum.Plot_State.Dry and c.plot_growth_state != Enum.Plot_Growth_State.Full:
			return c
	return null
	
func get_plot_that_needs_sun() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if c.plot_state == Enum.Plot_State.Wet and c.plot_growth_state != Enum.Plot_Growth_State.None:
			return c
	return null
	
func get_plot_that_needs_plucking() -> plot:
	for c in get_children():
		if !c is plot:
			continue
		if c.plot_growth_state == Enum.Plot_Growth_State.Full:
			return c
	return null
	

var square_position_array: Array[Vector2] = [
	Vector2(0, 0),
	Vector2(1, 0),
	Vector2(-1,0),
	Vector2(0, 1),
	Vector2(1, 1),
	Vector2(-1, 1),
	Vector2(0, 2),
	Vector2(1, 2),
	Vector2(-1, 2),
	Vector2(-2, 1),
	Vector2(-2, 0),
	Vector2(-2, 2),
	Vector2(2, 1),
	Vector2(2, 0),
	Vector2(2, 2),
	Vector2(0, 3),
	Vector2(1, 3),
	Vector2(-1, 3),
	Vector2(2, 3),
	Vector2(-2, 3),
	Vector2(0, 4),
	Vector2(1, 4),
	Vector2(-1, 4),
	Vector2(2, 4),
	Vector2(-2, 4),
	Vector2(-3, 2),
	Vector2(3, 2),
	Vector2(-3, 1),
	Vector2(3, 1),
	Vector2(-3, 3),
	Vector2(3, 3),
	Vector2(-3, 0),
	Vector2(3, 0),
	Vector2(-3, 4),
	Vector2(3, 4),
]


func update_push_zone(square_size: int) -> void:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	var squares = square_position_array.slice(0, plots.size())

	# Find bounds in tile coordinates
	for pos in squares:
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)

	# Convert to pixels
	var rect_width = (max_x - min_x + 1) * square_size
	var rect_height = (max_y - min_y + 1) * square_size
	var rect_center = Vector2(
		(min_x + max_x + 1) / 2.0 * square_size - square_size / 2,
		(min_y + max_y + 1) / 2.0 * square_size - square_size / 2
	)

	var shape = RectangleShape2D.new()
	shape.extents = Vector2(rect_width, rect_height) / 2.0
	$StaticBody2D/CollisionShape2D.shape = shape
	$StaticBody2D/CollisionShape2D.position = rect_center + Vector2(square_size/2,square_size/2)
	
