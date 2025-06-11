extends Node2D
class_name plot_grid



func _ready() -> void:
	PlotUtil.reset_plots()
	
func _process(_delta: float) -> void:
	pass




func get_square_position(index: int) -> Vector2:
	return square_position_array[index] if square_position_array.size() > index else Vector2.ZERO



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


	
