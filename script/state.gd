extends Node

var total_game_time: float = 0
var money: int = 0
var max_plots: int = 150
var num_plots: int = 1

var num_farmer_helpers: int = 0
var num_pluck_helpers: int = 0
var num_attack_helpers: int = 0

var num_farmer_hats: int = 0
var num_pluck_hats: int = 0
var num_attack_hats: int = 0

var enviornment_percentage: float = 0.0
var target_grass_scale: Vector2 = Vector2.ONE

var unlocked_slot_outputs: Array[Enum.Drop_Type] = []



var hit_strength: float = 1.0

var is_game_over: bool = false

var fire_attack_unlocked: bool = false
var electric_attack_unlocked: bool = false

var total_profit: int = 0
var total_piniata_clicks: int = 0
var total_seeds_planted: int = 0
var total_sold_crop_types := {}

var max_piniata_hp: int = 100000
var array_piniata_hp: Array[int] = [
	max_piniata_hp
]

var num_games_won = 0
var max_games = 4

var is_starting_new_game_plus: bool = false

func reset_new_game_plus_state() -> void:
	money = 0
	num_plots = 1

	num_farmer_helpers = 0
	num_pluck_helpers = 0
	num_attack_helpers = 0
	
	num_farmer_hats = 0
	num_pluck_hats = 0
	num_attack_hats = 0
	
	enviornment_percentage = 0.0
	target_grass_scale = Vector2.ONE
	
	unlocked_slot_outputs.clear()
	hit_strength = 1.0
	is_game_over = false
	fire_attack_unlocked = false
	electric_attack_unlocked = false
	
	num_games_won += 1
	
	array_piniata_hp.clear()
	for i in range(num_games_won + 1):
		array_piniata_hp.push_back(max_piniata_hp)


# List of keys to be saved/loaded automatically
const SAVE_KEYS := [
	"total_game_time", 
	"money",
	"num_plots", 
	"num_farmer_helpers", 
	"num_pluck_helpers", 
	"num_attack_helpers",
	"num_farmer_hats", 
	"num_pluck_hats", 
	"num_attack_hats",
	"unlocked_slot_outputs",
	"fire_attack_unlocked",
	"electric_attack_unlocked",
	"array_piniata_hp",
	"is_game_over",
	"total_profit",
	"total_piniata_clicks",
	"total_seeds_planted",
	"total_sold_crop_types"
]

func has_save_data() -> bool:
	return FileAccess.file_exists("user://savegame.save")
	
func load_game():
	var save_data = get_save_data()
	if not save_data:
		return

	for key in SAVE_KEYS:
		if key in save_data:
			if key == "unlocked_slot_outputs":
				unlocked_slot_outputs.clear()
				for i in save_data[key]:
					unlocked_slot_outputs.append(int(i))
			elif key == "array_piniata_hp":
				array_piniata_hp.clear()
				for i in save_data[key]:
					array_piniata_hp.append(int(i)) 
			else:
				print(key, ": ", save_data[key])
				self.set(key, save_data[key])
	
	if Debug.PRETTIEST_STATS:
		#State.num_plots = State.max_plots
		#State.unlocked_slot_outputs = [Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed, Enum.Drop_Type.Turnip_Seed, Enum.Drop_Type.Potato_Seed, Enum.Drop_Type.Kale_Seed, Enum.Drop_Type.Radish_Seed]
		#State.num_farmer_helpers = 5
		#State.num_attack_helpers = 3
		#State.num_pluck_helpers = 3
		State.num_plots = State.max_plots
		State.unlocked_slot_outputs = [Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed, Enum.Drop_Type.Turnip_Seed, Enum.Drop_Type.Potato_Seed, Enum.Drop_Type.Kale_Seed, Enum.Drop_Type.Radish_Seed]
		State.num_farmer_helpers = 40
		State.num_attack_helpers = 100
		State.num_pluck_helpers = 40
		State.fire_attack_unlocked = true
		State.electric_attack_unlocked = true
		#$Tutorial.visible = false
	
	# update money
	if Globals.CanvasLayerNode:
		Globals.CanvasLayerNode.update_money_counter()
	
	# update hats
	for i in range(num_attack_hats):
		DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, Util.random_visible_position() + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	for i in range(num_farmer_hats):
		DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, Util.random_visible_position() + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)
	for i in range(num_pluck_hats):
		DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, Util.random_visible_position() + Util.random_offset(32), Vector2.ZERO, Vector2.ZERO)

	# update helpers
	if Globals.HelpersContainerNode:
		var num_farmers = num_farmer_helpers
		num_farmer_helpers = 0
		for i in range(num_farmers):
			Globals.HelpersContainerNode.add_helper(Enum.Helper_Type.Farmer)
		var num_pluckers = num_pluck_helpers
		num_pluck_helpers = 0
		for i in range(num_pluckers):
			Globals.HelpersContainerNode.add_helper(Enum.Helper_Type.Pluck)
		var num_attackers = num_attack_helpers
		num_attack_helpers = 0
		for i in range(num_attackers):
			Globals.HelpersContainerNode.add_helper(Enum.Helper_Type.Attack)
	
	for pi in Globals.PiniataContainer.get_children():
		pi.update_health_bar()
	
	if is_game_over and Globals.Main:
		Globals.Main.on_game_over()


func save_game():
	if Debug.DONT_SAVE or State.is_game_over:
		return

	var save_dict = {}
	for key in SAVE_KEYS:
		save_dict[key] = self.get(key)

	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_line(JSON.stringify(save_dict))
	print("Saving game...")

func get_save_data():
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save file found")
		return null

	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json = JSON.new()
		var error = json.parse(line)
		if error != OK:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
			continue
		return json.get_data()

# havent tested this yet
func delete_save():
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save file found")
		return null
	DirAccess.remove_absolute("user://savegame.save")
	#Global.State().reset_state()
	#restart_scene()
	#get_tree().quit()
