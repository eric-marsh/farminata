extends CanvasLayer
class_name canvas_layer

@onready var onion_button = $MarginContainer/VBoxContainer/OnionButton


func _ready() -> void:
	update_money_counter()
	
func _process(_delta: float) -> void:
	pass
	
func update_money_counter():
	if !Globals.Main:
		return
	var money: int = State.money
	
	$MarginContainer/VBoxContainer/MoneyLabel.text = "$" + str(money)
	
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	$MarginContainer/VBoxContainer/PlotButton.text = "+1 Plot: $" + str(plot_price)
	$MarginContainer/VBoxContainer/PlotButton.disabled = plot_price > money
	
	var helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHelper)
	$MarginContainer/VBoxContainer/HelperButton.text = "+1 Helper: $" + str(helper_price)
	$MarginContainer/VBoxContainer/HelperButton.disabled = plot_price > money
	
	if State.unlocked_slot_outputs.has(Enum.Drop_Type.Onion_Seed):
		onion_button.visible = false
	else:
		var onion_price = Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockOnion)
		onion_button.text = "Unlock Onion: $" + str(onion_price)
		onion_button.disabled = onion_price > money

func _on_plot_button_pressed() -> void:
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	if !Globals.Main:
		return
		
	Globals.Main.change_money(-plot_price)
	State.num_plots += 1
	$"../PlotContainer/PlotGrid".add_plot() # TODO: If there is multiple plots, do this in a better way
	update_money_counter()


func _on_helper_button_pressed() -> void:
	var helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHelper)
	if !Globals.Main:
		return
	Globals.Main.change_money(-helper_price)
	State.num_helpers += 1
	Globals.HelpersContainerNode.add_helper()
	update_money_counter()


func _on_onion_button_pressed():
	if !Globals.SlotMachineNodde:
		return
	State.unlocked_slot_outputs.push_back(Enum.Drop_Type.Onion_Seed)
	Globals.SlotMachineNodde.unlock_drop_type(Enum.Drop_Type.Onion_Seed)
	Globals.PiniataNode.unlock_drop_type(Enum.Drop_Type.Onion_Seed)
	onion_button.visible = false
	
