extends Node

var Main: MainNode = null
var DropsNode: Node2D = null
var CanvasLayerNode: CanvasLayer = null
var CameraNode: Camera2D = null
var HelpersContainerNode: helpers_container = null
var AnimationsContainer: Node2D = null
var AudioNode: audio = null
var SellChestNode: Area2D = null
var PiniataNode: Node2D = null
var PlotsContainer: Node2D = null
var GrowArea: Area2D = null
var EnviornmentLayers: Area2D = null

func _ready():
	reset_nodes()
	
func _process(_delta: float) -> void:
	if !is_instance_valid(Main):
		reset_nodes()

func reset_nodes():
	Main = get_node("/root/SceneSwitcher/Main")
	DropsNode = get_node("/root/SceneSwitcher/Main/Drops")
	CanvasLayerNode = get_node("/root/SceneSwitcher/Main/CanvasLayer")
	CameraNode = get_node("/root/SceneSwitcher/Main/Camera2D")
	HelpersContainerNode = get_node("/root/SceneSwitcher/Main/Helpers")
	AnimationsContainer = get_node("/root/SceneSwitcher/Main/Animations")
	AudioNode = get_node("/root/SceneSwitcher/Main/Camera2D/Audio")
	SellChestNode = get_node("/root/SceneSwitcher/Main/SellChest")
	PiniataNode = get_node("/root/SceneSwitcher/Main/Piniata")
	PlotsContainer = get_node("/root/SceneSwitcher/Main/Plots")
	GrowArea = get_node("/root/SceneSwitcher/Main/GrowArea")
	EnviornmentLayers = get_node("/root/SceneSwitcher/Main/Enviornment")
