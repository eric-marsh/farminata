extends Area2D
class_name enviornment

static var good_enviornment_positions: Array[Vector2] = []

var enviornment_percentage: float = 1.0

const good_enviornment_images = [
	preload("res://img/enviornment/good/flower_1.png"),
	preload("res://img/enviornment/good/flower_2.png")
]

func _ready() -> void:
	reset_good_env()
	
func _process(_delta: float) -> void:
	animate_flowers()
	pass


var current_skew: float = 0.0
#var skew_dir: float = 0.002
var skew_dir: float = 0.0002

func animate_flowers():
	if abs(current_skew) > 0.2:
		skew_dir *= -1
	current_skew += skew_dir

	for f in $GoodLayer.get_children():
		f.skew = current_skew
		f.offset.x = tan(current_skew) * 8
		
		

func reset_good_env() -> void:
	total_good_sprites = 0
	for c in $GoodLayer.get_children():
		c.queue_free()
	reset_sprite_points()
	update_enviornment_layer(enviornment_percentage)

func update_enviornment_layer(percent: float): 
	var num_desired_sprites = total_good_sprites * percent
	
	var i: int = 0
	while i < num_desired_sprites - $GoodLayer.get_children().size() and good_enviornment_positions[0]:
		var s: Sprite2D = Sprite2D.new()
		s.texture = good_enviornment_images.pick_random()
		s.flip_h = Util.random_chance(0.5)
		s.global_position = good_enviornment_positions[0]
		good_enviornment_positions = good_enviornment_positions.slice(1)
		$GoodLayer.add_child(s)
		i += 1




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
	
