extends Area2D
class_name enviornment

static var good_enviornment_positions: Array[Vector2] = []


const good_enviornment_images = [
	preload("res://img/enviornment/good/bush_1.png"),
	preload("res://img/enviornment/good/flower_1.png"),
	preload("res://img/enviornment/good/flower_1.png"),
	preload("res://img/enviornment/good/flower_2.png"),
	preload("res://img/enviornment/good/flower_2.png"),
	preload("res://img/enviornment/good/grass_1.png")
]

func _ready() -> void:
	reset_good_env()
	


var current_skew: float = 0.0
var skew_dir: float = 0.0002

func reset_good_env() -> void:
	total_good_sprites = 0
	for c in $GoodLayer/Flowers.get_children():
		c.queue_free()
	for c in $GoodLayer/Snails.get_children():
		c.queue_free()
	reset_sprite_points()
	update_enviornment_layer()


const FLOWER = preload("res://flower.tscn")
const SNAIL = preload("res://scene/snail.tscn")
func update_enviornment_layer(): 
	var total_plots: int = PlotUtil.get_total_plots()
	if(total_plots < 3):
		if(total_plots > 2):
			$"../Tutorial".visible = false
			return
		return
	
	update_target_grass_scale()
	
	var num_flowers_to_add = 0
	if(total_plots < 20 and total_plots % 2 == 0):
		num_flowers_to_add = 1
	if total_plots > 20:
		num_flowers_to_add = 2
	
	
	add_flower()
	if total_plots > 20:
		add_flower()
		
	if total_plots > 80:
		add_flower()
	
	if total_plots % 4 == 0:
		add_lump()
	
	# maybe add snail
	if total_plots % 15 == 0 and Globals.PlotsContainer:
		var s = SNAIL.instantiate()
		s.global_position = Globals.PlotsContainer.remaining_plot_points[0]
		$GoodLayer/Snails.add_child(s)
	
	State.enviornment_percentage = float(State.num_plots) / float(State.max_plots)

func add_flower() -> void:
	var f = FLOWER.instantiate()
	f.get_node("FlowerSprite").texture = good_enviornment_images.pick_random()
	f.get_node("FlowerSprite").flip_h = Util.random_chance(0.5)
	f.get_node("FlowerSprite").offset.y = -6
	f.is_flower = true
	f.global_position = good_enviornment_positions[0] + Util.random_offset(4)
	
	good_enviornment_positions.push_back(good_enviornment_positions[0])
	good_enviornment_positions = good_enviornment_positions.slice(1)
	$GoodLayer/Flowers.add_child(f)

const lumps = [
	preload("res://img/enviornment/good/green_lump_1.png"),
	preload("res://img/enviornment/good/green_lump_2.png"),
]

func add_lump() -> void:
	var f = FLOWER.instantiate()
	f.get_node("FlowerSprite").texture = lumps.pick_random()
	f.get_node("FlowerSprite").flip_h = Util.random_chance(0.5)
	f.global_position = good_enviornment_positions[0] + Util.random_offset(4.0)
	good_enviornment_positions.push_back(good_enviornment_positions[0])
	good_enviornment_positions = good_enviornment_positions.slice(1)
	$GoodLayer/Flowers.add_child(f)

var min_scale = 1.0
var max_scale = 2.5
var min_plots_grass_growth: int = 3
func update_target_grass_scale():
	if State.num_plots < min_plots_grass_growth:
		return
	var growth_factor = log(State.num_plots + 1 - min_plots_grass_growth) / log(100 + 1)  # normalized [0, 1]
	var scale = lerp(min_scale, max_scale, growth_factor)
	State.target_grass_scale = Vector2(scale, scale)


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
	
