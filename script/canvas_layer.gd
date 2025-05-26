extends CanvasLayer
class_name canvas_layer

func _ready() -> void:
	update_money_counter()
	
func _process(delta: float) -> void:
	pass
	
func update_money_counter():
	if !Globals.Main:
		return
	var money: int = State.money
	
	$MarginContainer/VBoxContainer/MoneyLabel.text = "$" + str(money)
	
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	
	$MarginContainer/VBoxContainer/PlotButton.text = "+1 Plot: $" + str(plot_price)
	$MarginContainer/VBoxContainer/PlotButton.disabled = plot_price > money
	


func _on_plot_button_pressed() -> void:
	var plot_price = Prices.get_upgrade_price(Enum.Upgrade_Type.AddPlot)
	if !Globals.Main:
		return
		
	Globals.Main.change_money(-plot_price)
	State.num_plots += 1
	$"../PlotContainer/PlotGrid".add_plot() # TODO: If there is multiple plots, do this in a better way
	update_money_counter()
