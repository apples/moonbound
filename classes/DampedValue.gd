extends Reference
class_name DampedValue

var current
var target
var threshold
var smoothing: float

func _init(v, t, s: float):
	current = v
	target = v
	threshold = t
	smoothing = s

func update(delta: float):
	if current != target:
		current = lerp(current, target, 1.0 - pow(smoothing, delta))
		if abs(current - target) < threshold:
			current = target
