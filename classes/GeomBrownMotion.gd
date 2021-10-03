extends Reference
class_name GeomBrownMotion

const HISTORY_SIZE = 32

var current: float
var history: Array
var history_max: float
var drift: float
var volatility: float
var delta_t: float
var elapsed_t: float
var rng: RandomNumberGenerator

func _init(c: float, d: float, v: float, dt: float):
	current = c
	history = []
	for i in range(HISTORY_SIZE):
		history.append(c)
	history_max = 1 if current == 0 else current
	drift = d
	volatility = v
	delta_t = dt
	elapsed_t = 0
	rng = RandomNumberGenerator.new()
	rng.randomize()

func update(delta: float):
	elapsed_t += delta
	while elapsed_t >= delta_t:
		elapsed_t -= delta_t
		var dW = rng.randfn(0, sqrt(delta_t))
		var dS = (delta_t * drift + dW * volatility) * current
		current += dS
		history.append(current)
		history.pop_front()
		history_max = 1
		for x in history:
			history_max = max(history_max, x)
