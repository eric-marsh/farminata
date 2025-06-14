extends Node

var total_game_time: float = 0
var final_game_time: float = 0
var money: int = 0
var max_plots: int = 100
var num_plots: int = 1

var num_farmer_helpers: int = 0
var num_pluck_helpers: int = 0
var num_attack_helpers: int = 0

var enviornment_percentage: float = 0.0
var target_grass_scale: Vector2 = Vector2.ONE * 1.0

var unlocked_slot_outputs: Array[Enum.Drop_Type] = []


var max_piniata_hp: float = 100000
var piniata_hp: float = max_piniata_hp

var hit_strength: float = 1.0

# List of keys to be saved/loaded automatically
const SAVE_KEYS := [
	"total_game_time", 
	"final_game_time", 
	"money",
	"num_plots", 
	"num_farmer_helpers", 
	"num_pluck_helpers", 
	"num_attack_helpers",
	"piniata_hp", 
	"unlocked_slot_outputs"
]

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
			else:
				self.set(key, save_data[key])

func save_game():
	if Debug.DONT_SAVE:
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
	get_tree().quit()
