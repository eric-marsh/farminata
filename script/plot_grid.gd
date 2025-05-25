extends Control
class_name plot_grid

@export var num_plots = 10

var plots: Array[plot] = []
func _ready() -> void:
	reset_plots()
	pass
	
func _process(delta: float) -> void:
	reset_plots()
	pass

const PLOT = preload("res://scene/plot.tscn")
const PLOT_ROW = preload("res://scene/plot_row.tscn")
func reset_plots():
	# this isnt perfect, as it moves plots around. We will need a save system that keeps track of each row
	for c in $VBoxContainer.get_children():
		c.queue_free()
		
	plots.clear()	
		
	var num_columns: int = ceil(sqrt(num_plots))
	var num_plots_left = num_plots
	for i in range(num_columns):
		var row = PLOT_ROW.instantiate() as HBoxContainer
		$VBoxContainer.add_child(row)
		for j in range(num_columns):
			if num_plots_left <= 0:
				break
			var p = PLOT.instantiate() as plot
			row.add_child(p)
			plots.push_back(p)
			num_plots_left -= 1
		if num_plots_left <= 0:
			break
	
func get_random_plot_position() -> Vector2:
	#var p = $VBoxContainer.get_children()[0].get_children()[0] as plot
	
	#return p.global_position + p.size / 2
	var p = plots.pick_random()
	
	return p.global_position + p.size / 2
