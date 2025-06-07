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
		Enum.Upgrade_Type.AddSeedHelper:
			return max(4, State.num_seed_helpers * State.num_seed_helpers * 10)
		Enum.Upgrade_Type.AddWaterHelper:
			return max(4, State.num_water_helpers * State.num_water_helpers * 10)
		Enum.Upgrade_Type.AddSunHelper:
			return max(4, State.num_sun_helpers * State.num_sun_helpers * 10)
		Enum.Upgrade_Type.AddPluckHelper:
			return max(4, State.num_pluck_helpers * State.num_pluck_helpers * 10)
		Enum.Upgrade_Type.AddAttackHelper:
			return max(4, State.num_attack_helpers * State.num_attack_helpers * 10)
		Enum.Upgrade_Type.UnlockOnion:
			return 24
		Enum.Upgrade_Type.AddHat:
			return 20
			
			
	
