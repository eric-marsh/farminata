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
	Vector2(147, 100),
	Vector2(640-147, 100),
	Vector2(320, 200),
	Vector2(320, 100)
	
	
]

func add_piniatas():
	var index = 0
	for hp in State.array_piniata_hp:
		var p = PINIATA.instantiate() as piniata
		p.global_position = piniata_positions[index]
		p.id = index
		p.scale = Vector2(0.8, 0.8) if index > 0 else Vector2.ONE
		index += 1
		Globals.PiniataContainer.add_child(p)
	


var start_raining: bool = false

func _ready() -> void:
	Globals.reset_nodes()
	if !Debug.DONT_LOAD:
		State.load_game()
	#if Debug.DELETE_SAVE:
		#State.delete_save()
	
	global_timer = 0
	is_paused = false
	
	add_piniatas()
	
	if Debug.THUMBNAIL_MODE:
		State.unlocked_slot_outputs = [Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed, Enum.Drop_Type.Turnip_Seed, Enum.Drop_Type.Potato_Seed, Enum.Drop_Type.Kale_Seed, Enum.Drop_Type.Radish_Seed]
		State.num_farmer_helpers = 3
		State.num_attack_helpers = 0
		State.num_pluck_helpers = 1
		State.num_plots = 80
		Globals.CanvasLayerNode.visible = false
		$Camera2D.zoom = Vector2.ONE * 2
		$GrowArea/CollisionShape2D.shape.size = Vector2(622, 329)
		#scale = Vector2.ONE * 1.5
		Globals.PiniataContainer.get_children()[0].position = Vector2(320, 40)
		Globals.PiniataContainer.get_children()[0].get_node("HealthBar").visible = false
		$GrowArea/CollisionShape2D.position = Vector2(-23, -50)
		$Tutorial.visible = false
		$SellChest.visible = false
		$CanvasLayerLogo.visible = true
		$TileMapLayer.visible = false
	
	
	if Debug.START_WITH_ALL_CROPS_UNLOCKED:
		State.unlocked_slot_outputs = [Enum.Drop_Type.Carrot_Seed,Enum.Drop_Type.Onion_Seed,Enum.Drop_Type.Turnip_Seed,Enum.Drop_Type.Potato_Seed,Enum.Drop_Type.Kale_Seed, Enum.Drop_Type.Radish_Seed]
	
	if Debug.STARTING_MONEY > 0:
		change_money(Debug.STARTING_MONEY)
		
	if Debug.SPAWN_HATS:
		DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, Util.random_visible_position(), Vector2.ZERO)
	
	if Globals.CanvasLayerNode:
		Globals.CanvasLayerNode.update_money_counter()
		
	if Debug.HIDE_UI:
		Globals.CanvasLayerNode.visible = false
		
	


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

var key_8_presses: int = 0
func _input(event):
	if Debug.DEBUG_ENABLE_DEBUGGING_KEYS and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if Debug.ENABLE_CHEATS and event.is_action_pressed("KEY_8"):
		key_8_presses += 1
		if key_8_presses % 10 == 0:
			State.money += 10000
			Globals.CanvasLayerNode.update_money_counter()
	
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
