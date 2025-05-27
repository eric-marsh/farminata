extends Node
class_name GlobalsNode

var Main: MainNode = null
var Audio: Node2D = null
var PlotGrid: plot_grid = null
var DropsNode: Node2D = null
var CanvasLayerNode: CanvasLayer = null
var CameraNode: Camera2D = null
var HelpersContainerNode: helpers_container = null
var AnimationsContainer: Node2D = null

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
