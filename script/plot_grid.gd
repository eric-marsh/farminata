extends Node2D
class_name plot_grid

var num_plots = State.num_plots

var plots: Array[plot] = []
func _ready() -> void:
	reset_plots()
	
func _process(_delta: float) -> void:
	if Globals.Main.global_timer % 20 == 0:
		update_plots_to_check_for_drops()


func update_plots_to_check_for_drops():
	for c in get_children():
		if c is plot:
			c.find_wanted_drops()


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
	return square_position_array[index] if square_position_array.size() > index else Vector2.ZERO

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
