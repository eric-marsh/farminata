extends Node2D
class_name plot_grid

@export var num_plots = 10

var plots: Array[plot] = []
func _ready() -> void:
	for c in get_children():
		plots.push_back(c)
	pass
	
func _process(delta: float) -> void:
	pass

const PLOT = preload("res://scene/plot.tscn")
func reset_plots():
	for c in get_children():
		c.queue_free()
	
	var p = PLOT.instantiate() as plot
	add_child(p)
	plots.push_back(p)
	
func get_random_plot_position() -> Vector2:
	var p = plots.pick_random()
	return p.global_position + p.size / 2
