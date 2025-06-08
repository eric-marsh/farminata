extends CanvasLayer
class_name canvas_layer

@onready var plot_button = $MarginContainer/VBoxContainer/HBoxContainer/PlotButton
@onready var onion_button = $MarginContainer/VBoxContainer/HBoxContainer/OnionButton

@onready var add_seed_helper_button = $MarginContainer/VBoxContainer/HBoxContainer2/AddSeedHelperButton
@onready var add_sun_helper_button = $MarginContainer/VBoxContainer/HBoxContainer2/AddSunHelperButton
@onready var add_water_helper_button = $MarginContainer/VBoxContainer/HBoxContainer3/AddWaterHelperButton
@onready var add_pluck_helper_button = $MarginContainer/VBoxContainer/HBoxContainer3/AddPluckHelperButton
@onready var add_attack_helper_button = $MarginContainer/VBoxContainer/HBoxContainer4/AddAttackHelperButton


@onready var add_farmer_hat_button = $MarginContainer/VBoxContainer/HBoxContainer5/AddFarmerHatButton
@onready var add_delivery_hat_button = $MarginContainer/VBoxContainer/HBoxContainer5/AddDeliveryHatButton
@onready var add_attack_hat_button = $MarginContainer/VBoxContainer/HBoxContainer6/AddAttackHatButton

@onready var money_label = $MarginContainer/VBoxContainer/MoneyLabel




func _ready() -> void:
	update_money_counter()
	
func _process(_delta: float) -> void:
	pass
	
func update_money_counter():
	if !Globals.Main:
		return
	var money: int = State.money
	
	money_label.text = "$" + str(money)
	
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	
	plot_button.text = "+1 Plot: $" + str(plot_price)
	plot_button.disabled = plot_price > money
	
	
	
	var helper_data = [
		{ "type": Enum.Upgrade_Type.AddSeedHelper, "node": add_seed_helper_button, "count": State.num_seed_helpers, "icon": "🌱" },
		{ "type": Enum.Upgrade_Type.AddSunHelper, "node": add_sun_helper_button, "count": State.num_sun_helpers, "icon": "☀️" },
		{ "type": Enum.Upgrade_Type.AddWaterHelper, "node": add_water_helper_button, "count": State.num_water_helpers, "icon": "💧" },
		{ "type": Enum.Upgrade_Type.AddPluckHelper, "node": add_pluck_helper_button, "count": State.num_pluck_helpers, "icon": "🥕" },
		{ "type": Enum.Upgrade_Type.AddAttackHelper, "node": add_attack_helper_button, "count": State.num_attack_helpers, "icon": "🔫" },
	]

	for data in helper_data:
		var price = Prices.get_upgrade_price(data.type)
		data.node.text = "$" + str(price)
		data.node.disabled = price > money
	
	
	if State.unlocked_slot_outputs.has(Enum.Drop_Type.Onion_Seed):
		onion_button.visible = false
	else:
		var onion_price = Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockOnion)
		onion_button.text = "$" + str(onion_price)
		onion_button.disabled = onion_price > money
	
	# update hat buttons
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHat)
	add_farmer_hat_button.text = "$" + str(hat_price)
	add_farmer_hat_button.disabled = hat_price > money
	
	add_delivery_hat_button.text = "$" + str(hat_price)
	add_delivery_hat_button.disabled = hat_price > money
	
	add_attack_hat_button.text = "$" + str(hat_price)
	add_attack_hat_button.disabled = hat_price > money
	
	
	

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

func _on_add_attack_helper_button_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddAttackHelper, Enum.Helper_Type.Attack)

var spawn_hat_pos: Vector2 = Vector2(64, 64)
func _on_farmer_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHat)
	Globals.Main.change_money(-hat_price)
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()


func _on_delivery_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHat)
	Globals.Main.change_money(-hat_price)
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()


func _on_attack_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddHat)
	Globals.Main.change_money(-hat_price)
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()
