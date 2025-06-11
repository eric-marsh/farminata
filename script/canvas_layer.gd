extends CanvasLayer
class_name canvas_layer

@onready var money_label: Label = $MarginContainer/VBoxContainer/MoneyLabel

@onready var plot_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer/PlotButton
@onready var onion_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer/OnionButton
@onready var turnip_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer/TurnipButton
@onready var potato_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer2/PotatoButton
@onready var kale_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer2/KaleButton
@onready var radish_button: Button = $MarginContainer/VBoxContainer/FarmUpgrades/HBoxContainer2/RadishButton

@onready var add_farmer_helper: Button = $MarginContainer/VBoxContainer/HelperUpgrades/HBoxContainer/AddFarmerHelper
@onready var add_pluck_helper_button: Button = $MarginContainer/VBoxContainer/HelperUpgrades/HBoxContainer/AddPluckHelperButton
@onready var add_attack_helper_button: Button = $MarginContainer/VBoxContainer/HelperUpgrades/HBoxContainer/AddAttackHelperButton

@onready var add_farmer_hat_button: Button = $MarginContainer/VBoxContainer/HatUpgrades/HBoxContainer/AddFarmerHatButton
@onready var add_delivery_hat_button: Button = $MarginContainer/VBoxContainer/HatUpgrades/HBoxContainer/AddDeliveryHatButton
@onready var add_attack_hat_button: Button = $MarginContainer/VBoxContainer/HatUpgrades/HBoxContainer/AddAttackHatButton





func _ready() -> void:
	update_money_counter()
	
func _process(_delta: float) -> void:
	pass
	
func update_money_counter():
	if !Globals.Main:
		return
	var money: int = State.money
	money_label.text = "$" + str(money)

	var helper_data = [
		{ "type": Enum.Upgrade_Type.AddFarmerHelper, "node": add_farmer_helper, "count": State.num_farmer_helpers },
		{ "type": Enum.Upgrade_Type.AddPluckHelper, "node": add_pluck_helper_button, "count": State.num_pluck_helpers },
		{ "type": Enum.Upgrade_Type.AddAttackHelper, "node": add_attack_helper_button, "count": State.num_attack_helpers },
	]
	
	for data in helper_data:
		var price = Prices.get_upgrade_price(data.type)
		data.node.text = "$" + str(price)
		data.node.disabled = price > money
		var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
		plot_button.text = "$" + str(plot_price)
		plot_button.disabled = plot_price > money
	
	var seed_upgrades: Array = [
		{"seed": Enum.Drop_Type.Onion_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockOnion, "button": onion_button },
		{"seed": Enum.Drop_Type.Turnip_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockTurnip, "button": turnip_button },
		{"seed": Enum.Drop_Type.Potato_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockPotato, "button": potato_button },
		{"seed": Enum.Drop_Type.Kale_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockKale, "button": kale_button },
		{"seed": Enum.Drop_Type.Radish_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockRadish, "button": radish_button },
	]
	
	for seed in seed_upgrades:
		var price = Prices.get_upgrade_price(seed["upgrade_type"])
		seed["button"].text = "$" + str(price) if !State.unlocked_slot_outputs.has(seed["seed"]) else ""
		seed["button"].disabled = price > money or State.unlocked_slot_outputs.has(seed["seed"])
	
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
	PlotUtil.add_plot(Util.random_visible_position()) # TODO: If there is multiple plots, do this in a better way
	update_money_counter()



func add_helper_button_pressed(upgrade_type: Enum.Upgrade_Type, helper_type: Enum.Helper_Type) -> void:
	var helper_price = Prices.get_upgrade_price(upgrade_type)
	if !Globals.Main:
		return
	Globals.Main.change_money(-helper_price)
	Globals.HelpersContainerNode.add_helper(helper_type)
	update_money_counter()

func _on_add_farmer_helper_pressed() -> void:
	add_helper_button_pressed(Enum.Upgrade_Type.AddFarmerHelper, Enum.Helper_Type.Farmer)

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

func unlock_seed(seed: Enum.Drop_Type) -> void:
	State.unlocked_slot_outputs.push_back(seed)
	Globals.PiniataNode.unlock_drop_type(seed)
	update_money_counter()

func _on_onion_button_pressed():
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockOnion))
	unlock_seed(Enum.Drop_Type.Onion_Seed)

func _on_turnip_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockTurnip))
	unlock_seed(Enum.Drop_Type.Turnip_Seed)

func _on_potato_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockPotato))
	unlock_seed(Enum.Drop_Type.Potato_Seed)

func _on_kale_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockKale))
	unlock_seed(Enum.Drop_Type.Kale_Seed)

func _on_radish_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.UnlockRadish))
	unlock_seed(Enum.Drop_Type.Radish_Seed)
