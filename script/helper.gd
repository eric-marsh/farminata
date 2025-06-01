extends CharacterBody2D
class_name helper

@onready var anim = $AnimatedSprite2D
@onready var held_item_sprite = $HeldItem
@export var target_droppable: droppable = null
@export var target_plot: plot = null

var state: Enum.Helper_State = Enum.Helper_State.Idle
var dir: Enum.Dir = Enum.Dir.Down
var held_item_type: Enum.Drop_Type
var target_pos: Vector2 = Vector2.ZERO
var speed:int = 40

var min_velocity: Vector2 = Vector2(-speed, -speed)
var max_velocity: Vector2 = Vector2(speed, speed)

var state_timer_set: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.000001).timeout
	target_pos = global_position + Vector2(0, -100)
	
	set_state(Enum.Helper_State.Get_Item)
	
	update_animation()
	
	
	if Debug.Helper_Speed > 0:
		speed = Debug.Helper_Speed
		min_velocity = Vector2(-speed, -speed)
		max_velocity = Vector2(speed, speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(_delta: float) -> void:
	match(state):
		Enum.Helper_State.Idle:
			pass
		Enum.Helper_State.Wander:
			move_to_target()
		Enum.Helper_State.Get_Item:
			move_to_target()
		Enum.Helper_State.Deliver_Item:
			move_to_target()
		Enum.Helper_State.Pluck_Crop:
			move_to_target()

			

func set_state(s: Enum.Helper_State) -> void:
	held_item_sprite.visible = false
	state_timer_set = false
	match(s):
		Enum.Helper_State.Idle:
			clear_job_data()
			if !state_timer_set:
				state_timer_set = true
				Util.quick_timer(self, 0.4, func(): 
					if state == Enum.Helper_State.Idle:
						set_state(Enum.Helper_State.Wander)
				)
		Enum.Helper_State.Wander:
			clear_job_data()
			target_pos = Util.random_visible_position()
		Enum.Helper_State.Get_Item:
			if target_droppable == null:
				set_state(Enum.Helper_State.Idle)
				return
			target_pos = target_droppable.global_position
		Enum.Helper_State.Deliver_Item:
			target_droppable.is_held = true
			held_item_sprite.visible = true
			if target_droppable.is_produce:
				if Globals.SellChestNode:
					target_pos = Globals.SellChestNode.global_position + Vector2(32,-32)
			else:
				target_pos = target_plot.global_position + target_plot.size / 2
			
		Enum.Helper_State.Pluck_Crop:
			held_item_sprite.visible = false
			target_pos = target_plot.global_position + target_plot.size / 2

		
	state = s
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = Util.get_helper_state_string(state)
		$StateLabel.text += "1" if target_droppable != null else "0"
	#print(Util.get_helper_state_string(state), " timer: ", state_timer_set)
		

func move_to_target():
	if target_droppable:
		target_pos = target_droppable.global_position
	
	# if target reached
	if global_position.distance_to(target_pos) <= 2:
		if state == Enum.Helper_State.Get_Item and target_droppable:
			set_state(Enum.Helper_State.Deliver_Item)
			held_item_type = target_droppable.drop_type
			held_item_sprite.texture = target_droppable.get_node("Sprite2D").texture
			target_droppable.delete()
			target_droppable = null
			return
		if state == Enum.Helper_State.Deliver_Item:
			if target_plot:
				target_pos = target_plot.global_position + target_plot.size / 2
			else:
				if Globals.SellChestNode:
					target_pos = Globals.SellChestNode.global_position
			#spawn_droppable(drop_type: Enum.Drop_Type, position: Vector2, target_position: Vector2, impulse: Vector2 = Vector2.ZERO):
			var d = DropUtil.spawn_droppable(held_item_type, target_pos, Vector2.ZERO)
			d.start_static = true
			d.is_delivered = true
			remove_job()
			return
		if state == Enum.Helper_State.Pluck_Crop and target_plot:
			target_plot.pluck_crop()
		set_state(Enum.Helper_State.Idle)
	
	var direction = (target_pos - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
	velocity = direction * speed
	velocity = velocity.clamp(min_velocity, max_velocity)
	move_and_slide()

func remove_job():
	clear_job_data()
	set_state(Enum.Helper_State.Idle)

func clear_job_data():
	if is_instance_valid(target_droppable):
		target_droppable.is_being_targeted = false
	target_droppable = null
	target_plot = null
	$HeldItem.visible = false

func update_animation() -> void:
	match dir:
		Enum.Dir.Left:
			anim.play("walk_right")
			anim.flip_h = true
		Enum.Dir.Right:
			anim.play("walk_right")
			anim.flip_h = false
		Enum.Dir.Up:
			anim.play("walk_up")
			anim.flip_h = false
		Enum.Dir.Down:
			anim.play("walk_down")
			anim.flip_h = false
		_:
			print("Dont know that direction")
