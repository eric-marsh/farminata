extends Node2D
class_name plots_container

static var remaining_plot_points: Array[Vector2] = []

func _ready() -> void:
	PlotUtil.reset_plots()
	await get_tree().create_timer(0.01).timeout
	get_children()[0].global_position = Vector2(320, 240)
	 
