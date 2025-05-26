extends Node

#enum Drop_Type { Blurry, X, Water, Sun, Carrot_Seed, Carrot }

func get_price(symbol: Enum.Drop_Type) -> int:
	match symbol:
		Enum.Drop_Type.Carrot:
			return 1
		_:
			return 0
