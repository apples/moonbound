extends Reference
class_name LerpedValue

var prev
var current
var target setget _set_target
var time: float
var current_time: float

func _init(v, t: float):
	prev = v
	current = v
	target = v
	time = t
	current_time = t

func update(delta: float):
	if current_time < time:
		current_time += delta
		current = lerp(prev, target, min(current_time / time, 1.0))
	else:
		current = target

func _set_target(t):
	prev = current
	target = t
	current_time = 0
