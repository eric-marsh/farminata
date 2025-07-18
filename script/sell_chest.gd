extends Area2D
class_name sell_chest

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: AnimatedSprite2D = $AnimatedSprite2D/Shadow

var is_opened: bool = false
var droppable_to_sell: droppable = null

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	#DamageNumber.display_money_get(str("12"), animated_sprite.global_position + Vector2(12 + Util.rng.randi_range(-42, 0), -32), Color.GREEN)
	if !is_opened and animated_sprite.frame == 7:
		animated_sprite.play_backwards("default")
		shadow.play_backwards("default")
		
	
	if is_opened and droppable_to_sell and !droppable_to_sell.is_dragging:
		sell_droppable(droppable_to_sell)
		close_chest()
		# TODO: money animation



func sell_droppable(d: droppable, ignore_collision: bool = false) -> void:
	if !ignore_collision:
		var is_colliding:bool =false
		for b in get_overlapping_bodies():
			if d == droppable_to_sell:
				is_colliding = true
				break
		if !is_colliding:
			return
	
	State.total_sold_crop_types[d.drop_type] = State.total_sold_crop_types.get(d.drop_type, 0) + 1
	var price: int = Prices.get_drop_price(d.drop_type)
	Globals.Main.change_money(price)
	Util.create_explosion_particle(d.global_position, Color.YELLOW.lightened(0.5))
	if Globals.AudioNode:
		Globals.AudioNode.play_money_gain_sound()
	
	if d.is_sold_by_helper:
		Util.quick_timer(self, 0.4, func():
			DamageNumber.display_money_get(str(price), Globals.SellChestNode.global_position - Vector2(8, 64), Color.GREEN)
		)
	else:
		DamageNumber.display_money_get(str(price), d.global_position - Vector2(0, 16), Color.GREEN)
	d.delete()

func _on_body_entered(body: Node2D) -> void:
	if !body is droppable or !body.is_produce:
		return
	if !is_opened:
		open_chest(body)

func _on_body_exited(body: Node2D) -> void:
	if !body is droppable or !body.is_dragging or !body.is_produce:
		return
	if body == droppable_to_sell:
		#animated_sprite.play_backwards("default")
		close_chest()

func _on_animated_sprite_2d_animation_finished() -> void:
	if (!is_opened or !droppable_to_sell) and animated_sprite.frame > 0:
		animated_sprite.play_backwards("default")
		shadow.play_backwards("default")

func open_chest(d: droppable) -> void:
	is_opened = true
	droppable_to_sell = d
	animated_sprite.play("default")
	shadow.play("default")
	
func close_chest() -> void:
	droppable_to_sell = null
	is_opened = false
