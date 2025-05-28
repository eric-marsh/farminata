extends Area2D
class_name sell_chest

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_opened: bool = false
var droppable_to_sell: droppable = null

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if is_opened and droppable_to_sell and !droppable_to_sell.is_dragging:
		sell_droppable(droppable_to_sell)
		droppable_to_sell = null
		animated_sprite.play_backwards("default")
		is_opened = false
		# TODO: money animation

func sell_droppable(d: droppable):
	Globals.Main.change_money(Prices.get_drop_price(d.drop_type))
	#Util.create_explosion_particle(d.global_position, Color.YELLOW)
	d.delete()

func _on_body_entered(body: Node2D) -> void:
	if !body is droppable or !body.is_dragging or !body.is_produce:
		return
	if !is_opened:
		is_opened = true
		droppable_to_sell = body
		animated_sprite.play("default")

func _on_body_exited(body: Node2D) -> void:
	if !body is droppable or !body.is_dragging or !body.is_produce:
		return
	if body == droppable_to_sell:
		print("Dragging thing exited")
		animated_sprite.play_backwards("default")
		droppable_to_sell = null
		is_opened = false
