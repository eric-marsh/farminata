extends Node2D
class_name plots_container

func _ready() -> void:
	PlotUtil.reset_plots()
	
	if Debug.ALL_FULL_CROPS_AT_START:
		for p in get_children():
			print(p)
			if p is plot:
				p.plot_growth_state = Enum.Plot_Growth_State.Full
				p.grow_type = Enum.Grow_Type.Carrot
				p.update_image()
