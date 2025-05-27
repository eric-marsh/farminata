extends Node

func get_drop_price(symbol: Enum.Drop_Type) -> int:
	match symbol:
		Enum.Drop_Type.Carrot:
			return 1
		Enum.Drop_Type.Onion:
			return 2
		_:
			return 0

func get_upgrade_price(type: Enum.Upgrade_Type):
	match type:
		Enum.Upgrade_Type.AddPlot:
			return State.num_plots * State.num_plots
		Enum.Upgrade_Type.AddHelper:
			return State.num_helpers * State.num_helpers * 10
		Enum.Upgrade_Type.UnlockOnion:
			return 24
			
			
	
