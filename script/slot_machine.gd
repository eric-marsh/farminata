extends Area2D
class_name SlotMachineNode

@export var paired_plot_grid: plot_grid = null

var default_wait_time: float = 3.0
var min_spin_time: float = default_wait_time / 2
var slot_gap_time = (default_wait_time - min_spin_time) / 3

var possible_outputs: Array[Enum.Slot_Output] = [
	Enum.Slot_Output.X, 
	Enum.Slot_Output.X, 
	Enum.Slot_Output.Sun, 
	Enum.Slot_Output.Water, 
	Enum.Slot_Output.Carrot_Seed
	]
	
var slots: Array[Enum.Slot_Output] = [
	Enum.Slot_Output.X, 
	Enum.Slot_Output.X, 
	Enum.Slot_Output.X, 
]

func _ready() -> void:
	var default_wait_time: float = 3.0
	var min_spin_time: float = default_wait_time / 2
	var slot_gap_time = (default_wait_time - min_spin_time) / 3
	
	$SpinTimer.one_shot = true
	$SpinTimer.wait_time = default_wait_time
	update_slot_symbols_images()
	
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		output_all()
		if is_spinning():
			return
		start_spin_timer()
		
		
		

func output_all():
	for slot in $slot_symbols.get_children():
		var target_pos = paired_plot_grid.get_random_plot_position()
		slot.get_node("Output").spawn_droppable(target_pos)
	
func is_spinning() -> bool:
	return !$SpinTimer.is_stopped()

func start_spin_timer() -> void:
	$SpinTimer.start()
	set_all_slots(Enum.Slot_Output.Blurry)
	update_slot_symbols_images()
	
	Util.quick_timer(self, min_spin_time, func():
		set_next_slot_symbol()
	)

func set_next_slot_symbol():
	for i in range(slots.size()):
		if slots[i] == Enum.Slot_Output.Blurry:
			slots[i] = get_random_slot_output()
			update_slot_symbols_images()
			if i < slots.size() - 1:
				Util.quick_timer(self, slot_gap_time, func():
					set_next_slot_symbol()
				)
			else:
				$SpinTimer.stop() # stop timer just in case it doesnt line up. It doesnt
			return
	
func get_random_slot_output() -> Enum.Slot_Output:
	return possible_outputs[randi() % possible_outputs.size()]

func _on_spin_timer_timeout() -> void:
	# TODO: Do output
	pass

func set_all_slots(symbol: Enum.Slot_Output) -> void:
	for i in range(slots.size()):
		slots[i] = symbol

func update_slot_symbols_images() -> void:
	for i in range($slot_symbols.get_children().size()):
		$slot_symbols.get_children()[i].texture = Util.get_slot_output_img(slots[i])
	
