extends Node2D
class_name plot_grid

var num_plots = State.num_plots

var plots: Array[plot] = []
func _ready() -> void:
	reset_plots()
	
func _process(delta: float) -> void:
	if Globals.Main.global_timer % 20 == 0:
		update_plots_to_check_for_drops()


func update_plots_to_check_for_drops():
	for c in get_children():
		if c is plot:
			c.find_wanted_drops()


const PLOT = preload("res://scene/plot.tscn")
func reset_plots():
	for c in get_children():
		if c is plot:
			plots.push_back(c)
	for c in get_children():
		if c is plot:
			c.queue_free()
	
	var plots_left = num_plots
	while plots_left > 0:
		add_plot()
		plots_left -= 1


func add_plot():
	var p = PLOT.instantiate() as plot
	var square_pos = get_square_position(plots.size())
	p.position = square_pos * p.size
	add_child(p)
	plots.push_back(p)
	
	var tile_map_layer = $TileMapLayer as TileMapLayer
	var source_id: int = 2
	var terrain_set: int = 0
	tile_map_layer.set_cell(square_pos, source_id, Vector2i(1, 1), 0)
	tile_map_layer.set_cells_terrain_connect([square_pos], terrain_set, terrain_set)
	
func get_square_position(index: int) -> Vector2:
	var num_columns = ceil(sqrt(num_plots))
	match index:
		0: 
			return Vector2(0, 0)
		1: 
			return Vector2(1, 0)
		2: 
			return Vector2(0, 1)
		3: 
			return Vector2(1, 1)
		4: 
			return Vector2(2, 0)
		5: 
			return Vector2(2, 1)
		6: 
			return Vector2(0, 2)
		7: 
			return Vector2(1, 2)
		8: 
			return Vector2(2, 2)
		9: 
			return Vector2(3, 0)
		10: 
			return Vector2(3, 1)
		11: 
			return Vector2(3, 2)
		12: 
			return Vector2(0, 3)
		13: 
			return Vector2(1, 3)
		14: 
			return Vector2(2, 3)
		15: 
			return Vector2(3, 3)
		_:
			return Vector2.ZERO

func get_plot_for_helper():
	for c in get_children():
		if !c is plot:
			continue
		if !c.is_plot_needing_help():
			continue
		return c
	
func get_random_plot_position() -> Vector2:
	var p = plots.pick_random()
	return p.global_position + p.size / 2
