extends CanvasLayer
class_name canvas_layer

@onready var money_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/MoneyLabel
@onready var fps: Label = $MarginContainer/HBoxContainer3/FPS

@onready var plot_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/PlotButton
@onready var onion_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/OnionButton
@onready var turnip_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/TurnipButton
@onready var potato_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/PotatoButton
@onready var kale_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/KaleButton
@onready var radish_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer/RadishButton

@onready var attack_upgrade_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer2/AttackUpgradeButton


@onready var add_farmer_helper: Button = $MarginContainer/HBoxContainer2/HelperUpgrades/HBoxContainer/AddFarmerHelper
@onready var add_pluck_helper_button: Button = $MarginContainer/HBoxContainer2/HelperUpgrades/HBoxContainer/AddPluckHelperButton
@onready var add_attack_helper_button: Button = $MarginContainer/HBoxContainer2/HelperUpgrades/HBoxContainer2/AddAttackHelperButton

@onready var add_farmer_hat_button: Button = $MarginContainer/HBoxContainer2/HatUpgrades/HBoxContainer/AddFarmerHatButton
@onready var add_delivery_hat_button: Button = $MarginContainer/HBoxContainer2/HatUpgrades/HBoxContainer/AddDeliveryHatButton
@onready var add_attack_hat_button: Button = $MarginContainer/HBoxContainer2/HatUpgrades/HBoxContainer2/AddAttackHatButton

@onready var fire_attack_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer2/FireAttackButton
@onready var electric_attack_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer2/ElectricAttackButton


func _ready() -> void:
	update_money_counter()
	fps.visible = Debug.SHOW_FPS


func _process(_delta: float) -> void:
	if Debug.SHOW_FPS:
		fps.text = "FPS: " + str(Engine.get_frames_per_second())
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
	
	if PlotUtil.get_total_plots() < 100:
		var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
		plot_button.text = "$" + str(plot_price)
		plot_button.disabled = plot_price > money
	else:
		plot_button.text = ""
		plot_button.disabled = true
	
	var seed_upgrades: Array = [
		{"seed": Enum.Drop_Type.Onion_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockOnion, "button": onion_button },
		{"seed": Enum.Drop_Type.Turnip_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockTurnip, "button": turnip_button },
		{"seed": Enum.Drop_Type.Potato_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockPotato, "button": potato_button },
		{"seed": Enum.Drop_Type.Kale_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockKale, "button": kale_button },
		{"seed": Enum.Drop_Type.Radish_Seed, "upgrade_type": Enum.Upgrade_Type.UnlockRadish, "button": radish_button },
	]
	
	var seed_button_shown: bool = false
	for seed in seed_upgrades:
		var price = Prices.get_upgrade_price(seed["upgrade_type"])
		seed["button"].text = "$" + str(price) if !State.unlocked_slot_outputs.has(seed["seed"]) else ""
		seed["button"].disabled = price > money or State.unlocked_slot_outputs.has(seed["seed"])
		seed["button"].visible = false
		if !seed_button_shown and !State.unlocked_slot_outputs.has(seed["seed"]):
			seed_button_shown = true
			seed["button"].visible = true
			
	
	# update hat buttons
	var farmer_hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddFarmerHat)
	add_farmer_hat_button.text = "$" + str(farmer_hat_price)
	add_farmer_hat_button.disabled = farmer_hat_price > money
	
	var delivery_hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPluckHat)
	add_delivery_hat_button.text = "$" + str(delivery_hat_price)
	add_delivery_hat_button.disabled = delivery_hat_price > money
	
	var attack_hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddAttackHat)
	add_attack_hat_button.text = "$" + str(attack_hat_price)
	add_attack_hat_button.disabled = attack_hat_price > money
	
	# update attack buttons
	var fire_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddFireAttack)
	fire_attack_button.text = "$" + str(fire_price)
	if !State.fire_attack_unlocked:
		fire_attack_button.disabled = fire_price > money
	else:
		fire_attack_button.visible = false
	
	var electric_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddElectricAttack)
	electric_attack_button.text = "$" + str(electric_price)
	electric_attack_button.disabled = electric_price > money
	electric_attack_button.visible = (State.fire_attack_unlocked and !State.electric_attack_unlocked)
		
		
	if State.is_game_over:
		fire_attack_button.visible = false
		electric_attack_button.visible = false
		
	
	#@onready var fire_attack_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer2/FireAttackButton
#@onready var electric_attack_button: Button = $MarginContainer/HBoxContainer/FarmUpgrades/VBoxContainer/HBoxContainer2/ElectricAttackButton

	
	

func _on_plot_button_pressed() -> void:
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	if !Globals.Main:
		return
		
	Globals.Main.change_money(-plot_price)
	PlotUtil.add_plot() 
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

var spawn_hat_pos: Vector2 = Vector2(128, 256)
func _on_farmer_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddFarmerHat)
	Globals.Main.change_money(-hat_price)
	State.num_farmer_hats += 1
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()


func _on_delivery_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPluckHat)
	Globals.Main.change_money(-hat_price)
	State.num_pluck_hats += 1
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()


func _on_attack_hat_button_pressed():
	if !Globals.Main:
		return
	var hat_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddAttackHat)
	Globals.Main.change_money(-hat_price)
	State.num_attack_hats += 1
	var d = DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, spawn_hat_pos + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	update_money_counter()

func unlock_seed(seed: Enum.Drop_Type) -> void:
	State.unlocked_slot_outputs.push_back(seed)
	for p in Globals.PiniataContainer.get_children():
		p.unlock_drop_type(seed)
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


func _on_mute_music_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	if toggled_on:
		mute_music.icon = MUSIC
	else:
		mute_music.icon = MUSIC_DISABLED


	
const MUSIC = preload("res://img/ui/music.png")
const MUSIC_DISABLED = preload("res://img/ui/music_disabled.png")
@onready var mute_music: Button = $MarginContainer/HBoxContainer3/MuteMusic
var music_muted: bool = false
func _on_mute_music_pressed() -> void:
	if !Globals.AudioNode:
		return
	music_muted = !music_muted
	if music_muted:
		mute_music.icon = MUSIC_DISABLED
		Globals.AudioNode.mute_music()
	else:
		mute_music.icon = MUSIC
		Globals.AudioNode.unmute_music()

const EFFECTS = preload("res://img/ui/effects.png")
const EFFECTS_DISABLED = preload("res://img/ui/effects_disabled.png")
@onready var mute_effects: Button = $MarginContainer/HBoxContainer3/MuteEffects
var effects_muted: bool = false
func _on_mute_effects_pressed() -> void:
	effects_muted = !effects_muted
	if effects_muted:
		mute_effects.icon = EFFECTS_DISABLED
		Globals.AudioNode.mute_effects()
	else:
		mute_effects.icon = EFFECTS
		Globals.AudioNode.unmute_effects()



func _on_fire_attack_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.AddFireAttack))
	State.fire_attack_unlocked = true
	fire_attack_button.visible = false
	electric_attack_button.visible = true

func _on_electric_attack_button_pressed() -> void:
	Globals.Main.change_money(-Prices.get_upgrade_price(Enum.Upgrade_Type.AddElectricAttack))
	State.electric_attack_unlocked = true
	fire_attack_button.visible = false
	electric_attack_button.visible = false
