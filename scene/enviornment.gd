extends Area2D
class_name enviornment

static var good_enviornment_positions: Array[Vector2] = []


const good_enviornment_images = [
	preload("res://img/enviornment/good/flower_1.png"),
	preload("res://img/enviornment/good/flower_2.png")
]

func _ready() -> void:
	reset_good_env()
	


var current_skew: float = 0.0
var skew_dir: float = 0.0002

func reset_good_env() -> void:
	total_good_sprites = 0
	for c in $GoodLayer.get_children():
		c.queue_free()
	reset_sprite_points()
	update_enviornment_layer()


const FLOWER = preload("res://flower.tscn")
func update_enviornment_layer(): 
	if(State.num_plots > 2):
		$"../Tutorial".visible = false
		return
	
	if(State.num_plots < 5):
		return
	var num_flowers_to_add = 0
	if(State.num_plots < 20 and State.num_plots % 2 == 0):
		num_flowers_to_add = 1
	if State.num_plots > 20:
		num_flowers_to_add = 2
	
	
	# add one flower
	var f = FLOWER.instantiate()
	f.get_node("FlowerSprite").texture = good_enviornment_images.pick_random()
	f.get_node("FlowerSprite").flip_h = Util.random_chance(0.5)
	f.get_node("FlowerSprite").offset.y = -6
	f.global_position = good_enviornment_positions[0]
	good_enviornment_positions = good_enviornment_positions.slice(1)
	$GoodLayer.add_child(f)
	
	State.enviornment_percentage = float(State.num_plots) / float(State.max_plots)




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
	
