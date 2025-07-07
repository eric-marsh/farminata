extends Node2D
class_name MainNode

var global_timer: int = 0
var is_paused: bool = false

var max_blocks: int = 900
var is_dragging: bool = false
var dragged_droppable: droppable = null

const PINIATA = preload("res://scene/piniata.tscn")

var piniata_positions: Array[Vector2] = [
	Vector2(337, -5),
	Vector2(147, 100)
]

func add_piniatas():
	var index = 0
	print(State.array_piniata_hp)
	print(Globals.PiniataContainer)
	for hp in State.array_piniata_hp:
		var p = PINIATA.instantiate() as piniata
		p.global_position = piniata_positions[index]
		p.id = index
		index += 1
		Globals.PiniataContainer.add_child(p)
	

func _ready() -> void:
	if !Debug.DONT_LOAD:
		State.load_game()
	#if Debug.DELETE_SAVE:
		#State.delete_save()
	
	
	global_timer = 0
	is_paused = false
	Globals.reset_nodes()
	add_piniatas()
	
	if Debug.THUMBNAIL_MODE:
		State.num_farmer_helpers = 3
		State.num_attack_helpers = 0
		State.num_pluck_helpers = 1
		Globals.CanvasLayerNode.visible = false
		$Camera2D.zoom = Vector2.ONE * 2
		$GrowArea/CollisionShape2D.shape.size = Vector2(622, 329)
		#scale = Vector2.ONE * 1.5
		$Piniata.position = Vector2(320, 40)
		Globals.PiniataContainer.get_children()[0].get_node("HealthBar").visible = false
		$GrowArea/CollisionShape2D.position = Vector2(-23, -50)
		$Tutorial.visible = false
		$SellChest.visible = false
		$CanvasLayerLogo.visible = true
	
	
	
	if Debug.STARTING_MONEY > 0:
		change_money(Debug.STARTING_MONEY)
		
	if Debug.SPAWN_HATS:
		DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, Util.random_visible_position(), Vector2.ZERO)
	
	if Globals.CanvasLayerNode:
		Globals.CanvasLayerNode.update_money_counter()


var save_timer: float = 0.0
func _process(delta: float) -> void:
	if is_paused:
		return
		
	
	global_timer += 1
	State.total_game_time += delta
	save_timer += delta
	if save_timer >= 5.0:
		State.save_game()
		save_timer = 0.0
		DropUtil.update_all_droppable_counts_and_delete()
	
	Util.update_breeze()

func _input(event):
	if Debug.DEBUG_ENABLE_DEBUGGING_KEYS and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		call_deferred("stop_dragging_droppable") 

func stop_dragging_droppable() -> void:
	if dragged_droppable:
		dragged_droppable.stop_dragging()

func change_money(money_dif: int):
	if Globals.CanvasLayerNode:
		State.money += money_dif
		Globals.CanvasLayerNode.update_money_counter()
	
	if money_dif > 0:
		State.total_profit += money_dif
	
	# this is a really easy way to just play a noise when you buy an upgrade
	if money_dif < 0:
		if Globals.AudioNode:
			Globals.AudioNode.play_buy_upgrade_sound()


@onready var piniata: Node2D = $Piniata
@onready var dead_piniata: Sprite2D = $DeadPiniata

var wait_time_before_credits: float = 5.0
func on_game_over() -> void:
	if Debug.FAST_CREDITS:
		wait_time_before_credits = 0.1
	State.is_game_over = true
	Globals.HelpersContainerNode.on_game_over()
	Util.quick_timer(self, wait_time_before_credits, func():
		Globals.CanvasLayerCredits.start_credits()
	)
