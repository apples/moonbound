extends Node

var initial_drift = 0.1
var initial_volatility = 0.1
var delta_t = 0.25

var motions = {}

func get_current(mt):
	return motions[mt].current

func _ready():
	# Init current values
	for mtn in MarketType.Types:
		var mt = MarketType.Types[mtn]
		motions[mt] = GeomBrownMotion.new(
			100,
			initial_drift,
			initial_volatility,
			delta_t)
	motions[MarketType.Types.SPEED].volatility = 0.9
	motions[MarketType.Types.HEALTH].drift = 0.9

func _process(delta):
	for mt in motions:
		motions[mt].update(delta)
