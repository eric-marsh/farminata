extends Control
class_name plot

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Types = Enum.Grow_Types.None

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
