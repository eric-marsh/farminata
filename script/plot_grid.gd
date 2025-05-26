extends Node2D
class_name plot_grid

var num_plots = State.num_plots

var plots: Array[plot] = []
func _ready() -> void:
	reset_plots()
	
func _process(delta: float) -> void:
	pass

const PLOT = preload("res://scene/plot.tscn")
func reset_plots():
	for c in get_children():
		plots.push_back(c)
	for c in get_children():
		c.queue_free()
	
	var plots_left = num_plots
	while plots_left > 0:
		var p = PLOT.instantiate() as plot
		p.position = get_square_position(num_plots - plots_left) * p.size
		add_child(p)
		plots.push_back(p)
		plots_left -= 1


func add_plot():
	var p = PLOT.instantiate() as plot
	p.position = get_square_position(get_children().size()) * p.size
	add_child(p)
	plots.push_back(p)

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
		if !c.is_plot_needing_help():
			continue
		return c
	
func get_random_plot_position() -> Vector2:
	var p = plots.pick_random()
	return p.global_position + p.size / 2
