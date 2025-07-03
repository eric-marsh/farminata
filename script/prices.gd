extends Node

func get_drop_price(symbol: Enum.Drop_Type) -> int:
	match symbol:
		Enum.Drop_Type.Carrot:
			return 1
		Enum.Drop_Type.Onion:
			return 4
		Enum.Drop_Type.Turnip:
			return 8
		Enum.Drop_Type.Potato:
			return 16
		Enum.Drop_Type.Kale:
			return 32
		Enum.Drop_Type.Radish:
			return 64
		_:
			return 0

func get_upgrade_price(type: Enum.Upgrade_Type):
	match type:
		Enum.Upgrade_Type.AddPlot:
			return State.num_plots
		Enum.Upgrade_Type.AddFarmerHelper:
			return max(2, State.num_farmer_helpers * 4)
		Enum.Upgrade_Type.AddPluckHelper:
			return max(2, State.num_pluck_helpers  * 4)
		Enum.Upgrade_Type.AddAttackHelper:
			return max(2, State.num_attack_helpers * 4)
		Enum.Upgrade_Type.UnlockOnion:
			return 9
		Enum.Upgrade_Type.UnlockTurnip:
			return 80
		Enum.Upgrade_Type.UnlockPotato:
			return 240
		Enum.Upgrade_Type.UnlockKale:
			return 800
		Enum.Upgrade_Type.UnlockRadish:
			return 1600
		Enum.Upgrade_Type.AddFarmerHat:
			return 10 * (State.num_farmer_hats + 1)
		Enum.Upgrade_Type.AddAttackHat:
			return 10 * (State.num_attack_hats + 1)
		Enum.Upgrade_Type.AddPluckHat:
			return 10 * (State.num_pluck_hats + 1)
		Enum.Upgrade_Type.AddFireAttack:
			return 32
		Enum.Upgrade_Type.AddElectricAttack:
			return 128
			
		
