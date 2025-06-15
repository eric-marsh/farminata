extends CharacterBody2D
class_name helper

@export var id: int = 0
@export var id_of_type: int = 0
@export var helper_type: Enum.Helper_Type = Enum.Helper_Type.Farmer
@onready var anim = $AnimatedSprite2D 

var target_droppable: droppable = null
var target_plot: plot = null

var held_droppables: Array[droppable] = []


var state: Enum.Helper_State = Enum.Helper_State.Idle
var dir: Enum.Dir = Enum.Dir.Down
var target_pos: Vector2 = Vector2.ZERO
var speed:int = 40

var min_velocity: Vector2 = Vector2(-speed, -speed)
var max_velocity: Vector2 = Vector2(speed, speed)
var state_timer_set: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.001).timeout
	
	#set_state(Enum.Helper_State.Get_Item)
	set_state(Enum.Helper_State.Idle)
	update_animation()
	
	#$AnimatedSprite2D.modulate = Util.get_color_from_helper_type(helper_type).lightened(0.4)
	# TODO: This wont work with hat pickups
	configure_hat()
	
	if Debug.Helper_Speed > 0:
		update_speed(Debug.Helper_Speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()

func configure_hat()->void:
	match(helper_type):
		Enum.Helper_Type.Farmer:
			$HatSprite.visible = true
			$HatSprite.texture = DropUtil.get_drop_type_img(Enum.Drop_Type.Farm_Hat)
		Enum.Helper_Type.Pluck:
			$HatSprite.visible = true
			$HatSprite.texture = DropUtil.get_drop_type_img(Enum.Drop_Type.Delivery_Hat)
		Enum.Helper_Type.Attack:
			$HatSprite.visible = true
			$HatSprite.texture = DropUtil.get_drop_type_img(Enum.Drop_Type.Attack_Hat)
		_:
			pass

func _physics_process(_delta: float) -> void:
	var has_reached_target:bool = move_to_target()
	if has_reached_target:
		on_reaching_target_pos()
	
	update_hat_animation()
	
	if state == Enum.Helper_State.Get_Item and (!is_instance_valid(target_droppable) or target_droppable.is_held):
		target_droppable = null
		set_state(Enum.Helper_State.Idle)
		return
	
	if state == Enum.Helper_State.Wander and Globals.Main and Globals.Main.global_timer % 20 == 0:
		check_for_tasks_to_do()
		
		
	if state == Enum.Helper_State.Pluck_Crop && target_plot.plot_growth_state != Enum.Plot_Growth_State.Full:
		set_state(Enum.Helper_State.Idle)
	
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type))


func drop_held_item() ->void:
	# dont actually drop it for now, just delete
	held_droppables.clear()



func on_idle() -> void:
	# see if it can apply a droppable
	if held_droppables.size() > 0:
		for d in held_droppables:
			if !d:
				check_held_items_for_freed()
				d = null
				continue
			var p = PlotUtil.find_plot_for_droppable(d)
			if p:
				target_plot = p
				target_pos = target_plot.global_position
				set_state(Enum.Helper_State.Deliver_Item)
				return
	
	# look for droppable
	var d = find_droppable_based_on_helper_type()
	if d:
		target_droppable = d
		set_state(Enum.Helper_State.Get_Item)
		return
	
	# just wander
	set_state(Enum.Helper_State.Wander)

func on_plucker_idle() -> void:
	if !held_droppables.size():
		# first, check for any produce on the ground
		var d = find_droppable_based_on_helper_type()
		if d:
			target_droppable = d
			set_state(Enum.Helper_State.Get_Item)
			return
		# otherwise, check for pluckable plot
		var p:plot = PlotUtil.get_plot_that_needs_plucking()
		if p:
			target_plot = p
			target_pos = target_plot.global_position
			set_state(Enum.Helper_State.Pluck_Crop)
			return
	set_state(Enum.Helper_State.Wander)

func check_for_tasks_to_do() -> void:
	if helper_type == Enum.Helper_Type.Pluck:
		on_plucker_idle()
	else:
		on_idle()


var has_checked_for_tasks = false
func set_state(s: Enum.Helper_State) -> void:
	state = s
	match(state):
		Enum.Helper_State.Idle:
			if !has_checked_for_tasks:
				has_checked_for_tasks = true
				Util.quick_timer(self, 1.0, func():
					check_for_tasks_to_do()
					has_checked_for_tasks = false
				)
		Enum.Helper_State.Wander:
			target_pos = Util.random_visible_position()
		Enum.Helper_State.Get_Item:
			pass
		Enum.Helper_State.Deliver_Item:
			if helper_type == Enum.Helper_Type.Pluck and Globals.SellChestNode:
				target_pos = Globals.SellChestNode.global_position + Vector2(32,-32)
				return
			for d in held_droppables:
				var p = PlotUtil.find_plot_for_droppable(d)
				if p:
					target_plot = p
					target_pos = target_plot.global_position
					return
			# finding plot failed. Wander until a new one comes up
			set_state(Enum.Helper_State.Wander)
		Enum.Helper_State.Pluck_Crop:
			$HeldItem.visible = false
			target_pos = target_plot.global_position
		_:
			pass


var apply_upgrade: bool = false
var num_hats = 1
func equip_hat(d: droppable) -> void:
	var s: Sprite2D = Sprite2D.new()
	s.texture = d.get_node("Sprite2D").texture
	
	s.z_index=1
	s.y_sort_enabled=true
	if helper_type == Enum.Helper_Type.Attack:
		s.offset = Vector2(0, -25)
		s.position = Vector2(0, -4)
	else:
		s.offset = Vector2(0, -28)
		s.position = Vector2(0, -7)
	
	var current_hat = $HatSprite
	while current_hat.get_child_count() > 0:
		current_hat = current_hat.get_child(0)

	current_hat.add_child(s)
	num_hats += 1
	held_droppables.clear()
	# apply upgrade
	update_speed(10)
	if helper_type == Enum.Helper_Type.Attack:
		apply_upgrade = true
	

func on_reaching_target_pos() -> void:
	match(state):
		Enum.Helper_State.Idle:
			print("This should happen: Reached target as Idle")
			return
		Enum.Helper_State.Wander:
			set_state(Enum.Helper_State.Idle) # helper checks for items when idle
		Enum.Helper_State.Get_Item:
			if !target_droppable or !target_droppable.can_be_picked_up():
				target_droppable = null
				set_state(Enum.Helper_State.Idle)
				return
			if target_droppable.is_hat:
				equip_hat(target_droppable)
				target_droppable.hide_droppable()
				target_droppable.delete()
				target_droppable = null
				set_state(Enum.Helper_State.Idle)
				return
			pick_up_droppable(target_droppable)
			target_droppable = null
			set_state(Enum.Helper_State.Deliver_Item)
			return
		Enum.Helper_State.Deliver_Item:
			if held_droppables.size() == 0:
				target_plot = null
				held_droppables.clear()
				$HeldItem.visible = false
				set_state(Enum.Helper_State.Idle)
				return
			if target_plot and target_plot.is_droppable_being_applied:
				return
			# apply droppables
			for d in held_droppables:
				if !d:
					check_held_items_for_freed()
					d = null
					continue
				if target_plot and !PlotUtil.does_plot_need_droppable(d, target_plot):
					continue
				
				d.global_position = global_position
				if helper_type == Enum.Helper_Type.Pluck:
					DropUtil.create_apply_droppable_animation(d.drop_type, d.global_position, Globals.SellChestNode.global_position - Vector2(0, 8))
					Globals.SellChestNode.open_chest(d)
					Globals.SellChestNode.sell_droppable(d, true)
				else:
					target_plot.apply_droppable(d)
				#var appliedDrop = DropUtil.spawn_droppable(d.drop_type, target_pos, Vector2.ZERO)
				#appliedDrop.start_static = true
				#appliedDrop.is_delivered = true
				target_plot = null
				hide_held_item(d)
				d.delete()
				set_state(Enum.Helper_State.Idle)
				return
				pass	
			# couldnt deliver. Restart
			target_plot = null
			set_state(Enum.Helper_State.Idle)
		Enum.Helper_State.Pluck_Crop:
			if target_plot.plot_growth_state == Enum.Plot_Growth_State.Full:
				target_plot.pluck_crop()
			target_plot = null
			set_state(Enum.Helper_State.Idle)
		_:
			pass


func find_droppable_based_on_helper_type() -> droppable:
	if !Globals.DropsNode:
		return null
	var d: droppable = null
	match(helper_type):
		Enum.Helper_Type.Farmer:
			if !is_holding_seed():
				d = DropUtil.get_highest_seed()
				if d:
					return d
			if !is_holding_drop_type(Enum.Drop_Type.Water):
				d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Water)
				if d:
					return d
			if !is_holding_drop_type(Enum.Drop_Type.Sun):
				d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Sun) 
				if d:
					return d
		Enum.Helper_Type.Pluck:
			d = DropUtil.get_highest_produce()
	return d





func is_holding_drop_type(d_type: Enum.Drop_Type) -> bool:
	for temp_drop in held_droppables:
		if temp_drop and temp_drop.drop_type == d_type:
			return true
	return false
	
func is_holding_seed() -> bool:
	for temp_drop in held_droppables:
		if temp_drop and DropUtil.is_seed(temp_drop.drop_type):
			return true
	return false

func pick_up_droppable(d: droppable) -> void:
	if !is_instance_valid(d) or d.is_held or DropUtil.is_hat(d.drop_type) or  (helper_type != Enum.Helper_Type.Pluck and DropUtil.is_produce(d.drop_type)):
		return
	
	for temp_drop in held_droppables:
		if !temp_drop:
			check_held_items_for_freed()
			temp_drop = null
			continue
		if temp_drop.drop_type == d.drop_type:
			return
	held_droppables.push_back(d)
	d.is_held = true
	$HeldItem.visible = true
	#d.delete()
	d.hide_droppable()
	
	# update images
	if DropUtil.is_seed(d.drop_type):
		$HeldItem/HeldItem1.visible = true
		$HeldItem/HeldItem1.texture = d.get_node("Sprite2D").texture
	
	if d.drop_type == Enum.Drop_Type.Water:
		$HeldItem/HeldItem2.visible = true
		$HeldItem/HeldItem2.texture = d.get_node("Sprite2D").texture
	
	if d.drop_type == Enum.Drop_Type.Sun:
		$HeldItem/HeldItem3.visible = true
		$HeldItem/HeldItem3.texture = d.get_node("Sprite2D").texture
	
	if DropUtil.is_produce(d.drop_type):
		$HeldItem/HeldItemProduce.visible = true
		$HeldItem/HeldItemProduce.texture = d.get_node("Sprite2D").texture
	
	

func check_held_items_for_freed()->void:
	for i in range(held_droppables.size() - 1, -1, -1):
		if !is_instance_valid(held_droppables[i]):
			held_droppables.remove_at(i)
			break
		

func hide_held_item(d:droppable) -> void:
	if DropUtil.is_seed(d.drop_type):
		$HeldItem/HeldItem1.visible = false
		
	if d.drop_type == Enum.Drop_Type.Water:
		$HeldItem/HeldItem2.visible = false
		
	if d.drop_type == Enum.Drop_Type.Sun:
		$HeldItem/HeldItem3.visible = false
		
	if DropUtil.is_produce(d.drop_type):
		$HeldItem/HeldItemProduce.visible = false
		
	for i in range(held_droppables.size() - 1, -1, -1):
		var temp_drop = held_droppables[i]
		if temp_drop == d:
			held_droppables.remove_at(i)
			break


func move_to_target() -> bool:
	if state == Enum.Helper_State.Idle:
		return false
	if target_droppable:
		target_pos = target_droppable.global_position
	
	if state == Enum.Helper_State.Get_Item and global_position.distance_to(target_pos) <= 2:
		return true
	if helper_type == Enum.Helper_Type.Attack:
		if global_position.distance_to(target_pos) <= 2:
			return true
	else:
		if global_position.distance_to(target_pos) <= 32:
			return true
	
	
	
	var direction = (target_pos - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
	velocity = direction * speed
	velocity = velocity.clamp(min_velocity, max_velocity)
	move_and_slide()
	
	return false

func update_speed(s:int)->void:
	speed += s
	min_velocity = Vector2(-speed, -speed)
	max_velocity = Vector2(speed, speed)

func update_hat_animation() -> void:
	if [1,2,5,6].has($AnimatedSprite2D.frame):
		$HatSprite.position = Vector2(0, 1)
	else:
		$HatSprite.position = Vector2(0, 0)


@onready var hat_sprite: Sprite2D = $HatSprite
func update_animation() -> void:
	match dir:
		Enum.Dir.Left:
			anim.play("walk_right")
			anim.flip_h = true
			hat_sprite.flip_h = true
		Enum.Dir.Right:
			anim.play("walk_right")
			anim.flip_h = false
			hat_sprite.flip_h = false
		Enum.Dir.Up:
			#anim.play("walk_up")
			anim.play("walk_right")
		Enum.Dir.Down:
			anim.play("walk_down")
			anim.flip_h = false
			hat_sprite.flip_h = false
		_:
			print("Dont know that direction")
	if helper_type == Enum.Helper_Type.Pluck:
		if hat_sprite.flip_h:
			$HatSprite.offset.x = -3
		else:
			$HatSprite.offset.x = 3


func _on_grab_droppables_area_body_entered(body: Node2D) -> void:
	if body is droppable:
		pick_up_droppable(body)
