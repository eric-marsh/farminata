extends Node2D
class_name plots_container

static var remaining_plot_points: Array[Vector2] = []

func _ready() -> void:
	PlotUtil.reset_plots()
	 
