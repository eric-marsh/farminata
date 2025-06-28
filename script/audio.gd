extends Node2D
class_name audio

@onready var music: AudioStreamPlayer2D = $Music
@onready var grass: AudioStreamPlayer2D = $Grass
@onready var plant: AudioStreamPlayer2D = $Plant
@onready var mouse: AudioStreamPlayer2D = $Mouse
@onready var money: AudioStreamPlayer2D = $Money
@onready var apply_droppable: AudioStreamPlayer2D = $ApplyDroppable
@onready var buy_upgrade: AudioStreamPlayer2D = $BuyUpgrade



func _ready() -> void:
	if Debug.ALWAYS_MUTE:
		AudioServer.set_bus_mute( AudioServer.get_bus_index("Master"), true) # or false
		return
		
	music.connect("finished", Callable(self,"_on_loop_music").bind($Music))
	music.play()
	
	pass

func _process(_delta: float) -> void:
	pass


func unmute_effects() -> void:
	AudioServer.set_bus_mute( AudioServer.get_bus_index("Effects"), false)

func mute_effects() -> void:
	AudioServer.set_bus_mute( AudioServer.get_bus_index("Effects"), true)

func unmute_music() -> void:
	AudioServer.set_bus_mute( AudioServer.get_bus_index("Music"), false)

func mute_music() -> void:
	AudioServer.set_bus_mute( AudioServer.get_bus_index("Music"), true)

func _on_loop_music(_player):
	$Music.play()


const grass_sounds = [
	preload("res://audio/grass/footstep_grass_000.ogg"),
	preload("res://audio/grass/footstep_grass_001.ogg"),
	preload("res://audio/grass/footstep_grass_002.ogg"),
	preload("res://audio/grass/footstep_grass_003.ogg"),
	preload("res://audio/grass/footstep_grass_004.ogg")
]

const BONG_001 = preload("res://audio/ui/bong_001.ogg")
func play_pickup_sound():
	mouse.stream = BONG_001
	mouse.play()

const DROP_002 = preload("res://audio/plant/drop_002.ogg")
func play_pluck_sound():
	plant.stream = DROP_002
	plant.play()

func play_grass_sound():
	grass.stream = grass_sounds.pick_random()
	grass.play()

const DROP_003 = preload("res://audio/plant/drop_003.ogg")
const DROP_004 = preload("res://audio/plant/drop_004.ogg")

func play_apply_droppable_sound():
	apply_droppable.play()

func play_start_grow_sound():
	plant.stream = DROP_004
	plant.play()


func play_done_grow_sound():
	plant.stream = DROP_004
	plant.play()


func play_money_gain_sound():
	money.play()

func play_buy_upgrade_sound():
	buy_upgrade.play()


@onready var hit_piniata: AudioStreamPlayer2D = $HitPiniata

var hit_piniata_sounds = [
	preload("res://audio/piniata/SFX-impact-punch-bag-01_wav.wav"),
	preload("res://audio/piniata/SFX-impact-punch-bag-02_wav.wav"),
	preload("res://audio/piniata/SFX-impact-punch-bag-03_wav.wav"),
	preload("res://audio/piniata/SFX-impact-punch-bag-04_wav.wav"),
	preload("res://audio/piniata/SFX-impact-punch-bag-05_wav.wav")
]


@onready var hit_piniata_flame: AudioStreamPlayer2D = $HitPiniataFlame
func play_pinitata_flame():
	hit_piniata_flame.play()
	
@onready var hit_piniata_electricity: AudioStreamPlayer2D = $HitPiniataElectricity
func play_pinitata_electricity():
	hit_piniata_electricity.pitch_scale = 0.8 + Util.rng.randf_range(0.0, 2.0)
	hit_piniata_electricity.play()

func play_hit_piniata_sound():
	hit_piniata.stream = hit_piniata_sounds.pick_random()
	hit_piniata.play()



var slot_spin_assigned_id:int = -1
func play_slot_spin(id):
	slot_spin_assigned_id = id
	$SlotSpin.play(0.0)
	
func unplay_slot_spin(id):
	if id == slot_spin_assigned_id:
		$SlotSpin.stop()
