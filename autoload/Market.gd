extends Node

var initial_drift = 0
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

func _process(delta):
	for mt in motions:
		if motions[mt].current > 190:
			motions[mt].drift = -1.0
		elif motions[mt].current < 10:
			motions[mt].drift = 1.0
		else:
			motions[mt].drift = 0.0
		motions[mt].update(delta)
