extends Control
class_name plot


const PLOT_WET = preload("res://img/plot/plot_wet.png")
const PLOT_DRY = preload("res://img/plot/plot_dry.png")

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Types = Enum.Grow_Types.None

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body emtered")
	if !body.is_in_group("droppable"):
		return
	print("body ios droppable")
	apply_droppable(body)
	


#{ Blurry, X, Water, Sun, Carrot_Seed }
func apply_droppable(d: droppable):
	match d.output_type:
		Enum.Output_Type.Water:
			if plot_state == Enum.Plot_State.Dry:
				plot_state = Enum.Plot_State.Wet
				update_plot()
				d.queue_free()
				return
				
				

func update_plot():
		match plot_state:
			Enum.Plot_State.Dry:
				$NinePatchRect.texture = PLOT_DRY
			Enum.Plot_State.Wet:
				$NinePatchRect.texture = PLOT_WET
			
			
			
			
