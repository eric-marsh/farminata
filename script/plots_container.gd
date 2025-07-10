extends Node2D
class_name plots_container

static var remaining_plot_points: Array[Vector2] = []

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	PlotUtil.reset_plots()
	
	
	 
