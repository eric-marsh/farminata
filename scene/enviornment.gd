extends Area2D
class_name enviornment

static var good_enviornment_positions: Array[Vector2] = []

const FLOWER_1 = preload("res://img/enviornment/good/flower_1.png")
const FLOWER_2 = preload("res://img/enviornment/good/flower_2.png")


func _ready() -> void:
	reset_sprite_points()
	
	update_good_enviornment_layer(0.1)
	
func _process(_delta: float) -> void:
	pass


func update_good_enviornment_layer(percent: float): 
	var num_desired_sprites = total_good_sprites * percent
	
	for i in range(num_desired_sprites - $GoodLayer.get_children().size()):
		var s: Sprite2D = Sprite2D.new()
		s.texture = FLOWER_1
		s.global_position = good_enviornment_positions[0]
		good_enviornment_positions = good_enviornment_positions.slice(1)
		$GoodLayer.add_child(s)

var total_good_sprites: float = 0
func reset_sprite_points():
	var width: float = $CollisionShape2D.shape.extents.x * 2 + 32
	var height: float = $CollisionShape2D.shape.extents.y * 2 + 32
	
	var num_cols = width / 16 
	var num_rows = height / 16 
	total_good_sprites = num_cols * num_rows
	var total_spr
	good_enviornment_positions.clear()
	for i in range(num_cols):
		for j in range(num_rows):
			var pos = Vector2((width/num_cols) * i, (height/num_rows) * j) + global_position - $CollisionShape2D.shape.extents * 2 + Util.random_offset(8)
			good_enviornment_positions.push_back(pos)
	good_enviornment_positions.shuffle()
	
