extends Node



var current_values = {}






func _ready():
	# Init current values
	for mt in MarketType.Types:
		current_values[mt] = 0

func _process(delta):
	pass
