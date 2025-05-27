extends Area2D
class_name slot_machine

@export var paired_plot_grid: plot_grid = null

var default_wait_time: float = Debug.SLOT_MACHINE_WAIT_TIME
var min_spin_time: float = default_wait_time / 2
var slot_gap_time = (default_wait_time - min_spin_time) / 3

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.X, 
	Enum.Drop_Type.X, 
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]
	
var slots: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.X, 
	Enum.Drop_Type.X, 
	Enum.Drop_Type.X, 
]


var initial_pos: Vector2 = Vector2.ZERO
func _ready() -> void:

	for o in State.unlocked_slot_outputs:
		possible_outputs.push_back(o)
	
	initial_pos = global_position
	var default_wait_time: float = 3.0
	var min_spin_time: float = default_wait_time / 2
	var slot_gap_time = (default_wait_time - min_spin_time) / 3
	
	$SpinTimer.one_shot = true
	$SpinTimer.wait_time = default_wait_time
	update_slot_symbols_images()
	
	
	
func _process(delta: float) -> void:
	if is_spinning() and Globals.Main and Globals.Main.global_timer % 4 == 0:
		apply_shake()
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if is_spinning(): 
			return
		start_spin_timer()

func apply_shake() -> void:
	global_position = initial_pos + Util.random_offset(0.4)

func is_spinning() -> bool:
	return !$SpinTimer.is_stopped()

func start_spin_timer() -> void:
	$SpinTimer.start()
	set_all_slots(Enum.Drop_Type.Blurry)
	update_slot_symbols_images()
	
	#$slot_symbols.visible = false
	$slot_symbols/slot_1.visible = false
	$slot_symbols/slot_2.visible = false
	$slot_symbols/slot_3.visible = false
	$slots_animation.visible = true
	$SlotsSpinAnimation.play("spin_slots")
	Util.quick_timer(self, min_spin_time, func():
		set_next_slot_symbol()
	)




func set_next_slot_symbol():
	for i in range(slots.size()):
		if slots[i] == Enum.Drop_Type.Blurry:
			var output_type = get_random_slot_output()
			slots[i] = output_type
			#var target_pos = paired_plot_grid.get_random_plot_position()
			var target_pos = Vector2.ZERO
			
			
			update_slot_symbols_images()
			$slot_symbols.get_children()[i].visible = true
			
			
			# spawn output
			if DropUtil.is_valid_droppable_type(output_type):
				$slot_symbols.get_children()[i].get_node("Output").trigger_output(output_type, target_pos)
			
			if i < slots.size() - 1:
				Util.quick_timer(self, slot_gap_time, func():
					set_next_slot_symbol()
				)
			else:
				$SpinTimer.stop() # stop timer just in case it doesnt line up. It doesnt
			return

func get_random_slot_output() -> Enum.Drop_Type:
	return possible_outputs[randi() % possible_outputs.size()]

func _on_spin_timer_timeout() -> void:
	$slots_animation.visible = false
	$SlotsSpinAnimation.stop()
	global_position = initial_pos

func set_all_slots(symbol: Enum.Drop_Type) -> void:
	for i in range(slots.size()):
		slots[i] = symbol

func update_slot_symbols_images() -> void:
	for i in range($slot_symbols.get_children().size()):
		$slot_symbols.get_children()[i].texture = DropUtil.get_drop_type_img(slots[i])
	
	

func unlock_drop_type(type: Enum.Drop_Type) -> void:
	if !possible_outputs.has(type):
		possible_outputs.push_back(type)
