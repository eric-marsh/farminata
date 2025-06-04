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
	
	var seed_helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddSeedHelper)
	$MarginContainer/VBoxContainer/AddSeedHelperButton.text = str(State.num_seed_helpers) + " 🌱: $" + str(seed_helper_price)
	$MarginContainer/VBoxContainer/AddSeedHelperButton.disabled = seed_helper_price > money
	
	var sun_helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddSunHelper)
	$MarginContainer/VBoxContainer/AddSunHelperButton.text = str(State.num_sun_helpers) + " ☀️: $" + str(sun_helper_price)
	$MarginContainer/VBoxContainer/AddSunHelperButton.disabled = sun_helper_price > money
	
	var water_helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddWaterHelper)
	$MarginContainer/VBoxContainer/AddWaterHelperButton.text = str(State.num_water_helpers) + " 💧: $" + str(water_helper_price)
	$MarginContainer/VBoxContainer/AddWaterHelperButton.disabled = water_helper_price > money
	
	var pluck_helper_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPluckHelper)
	$MarginContainer/VBoxContainer/AddPluckHelperButton.text = str(State.num_pluck_helpers) + " 🥕: $" + str(pluck_helper_price)
	$MarginContainer/VBoxContainer/AddPluckHelperButton.disabled = pluck_helper_price > money
	
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





func _on_onion_button_pressed():
	if !Globals.SlotMachineNodde:
		return
	State.unlocked_slot_outputs.push_back(Enum.Drop_Type.Onion_Seed)
	Globals.SlotMachineNodde.unlock_drop_type(Enum.Drop_Type.Onion_Seed)
	Globals.PiniataNode.unlock_drop_type(Enum.Drop_Type.Onion_Seed)
	onion_button.visible = false



func add_helper_button_pressed(upgrade_type: Enum.Upgrade_Type, helper_type: Enum.Helper_Type) -> void:
	var helper_price = Prices.get_upgrade_price(upgrade_type)
	if !Globals.Main:
		return
	Globals.Main.change_money(-helper_price)
	Globals.HelpersContainerNode.add_helper(helper_type)
	update_money_counter()
	
		


func _on_add_seed_helper_button_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddSeedHelper, Enum.Helper_Type.Seed)


func _on_add_sun_helper_button_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddSunHelper, Enum.Helper_Type.Sun)


func _on_add_water_helper_button_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddWaterHelper, Enum.Helper_Type.Water)


func _on_add_pluck_helper_button_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddPluckHelper, Enum.Helper_Type.Pluck)
