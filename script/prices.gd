extends Node

func get_drop_price(symbol: Enum.Drop_Type) -> int:
	match symbol:
		Enum.Drop_Type.Carrot:
			return 1
		Enum.Drop_Type.Onion:
			return 2
		Enum.Drop_Type.Turnip:
			return 4
		Enum.Drop_Type.Potato:
			return 8
		Enum.Drop_Type.Kale:
			return 16
		Enum.Drop_Type.Radish:
			return 32
		_:
			return 0

func get_upgrade_price(type: Enum.Upgrade_Type):
	match type:
		Enum.Upgrade_Type.AddPlot:
			return State.num_plots * State.num_plots + 4
		Enum.Upgrade_Type.AddFarmerHelper:
			return max(2, State.num_farmer_helpers * State.num_farmer_helpers * 4)
		Enum.Upgrade_Type.AddPluckHelper:
			return max(2, State.num_pluck_helpers * State.num_pluck_helpers * 4)
		Enum.Upgrade_Type.AddAttackHelper:
			return max(2, State.num_attack_helpers * State.num_attack_helpers * 4)
		Enum.Upgrade_Type.UnlockOnion:
			return 10
		Enum.Upgrade_Type.UnlockTurnip:
			return 40
		Enum.Upgrade_Type.UnlockRadish:
			return 80
		Enum.Upgrade_Type.UnlockPotato:
			return 120
		Enum.Upgrade_Type.UnlockKale:
			return 240
		Enum.Upgrade_Type.UnlockRadish:
			return 480
		Enum.Upgrade_Type.AddHat:
			return 20
			
			
	
