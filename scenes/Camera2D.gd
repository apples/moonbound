extends Camera2D

export(float) var lerp_time = 0.5

var limit_left_lerp = LerpedValue.new(self.limit_left, lerp_time)
var limit_right_lerp = LerpedValue.new(self.limit_right, lerp_time)
var limit_top_lerp = LerpedValue.new(self.limit_top, lerp_time)
var limit_bottom_lerp = LerpedValue.new(self.limit_bottom, lerp_time)

func _ready():
	pass

func _process(delta):
	limit_left_lerp.update(delta)
	limit_right_lerp.update(delta)
	limit_top_lerp.update(delta)
	limit_bottom_lerp.update(delta)
	limit_left = limit_left_lerp.current
	limit_right = limit_right_lerp.current
	limit_top = limit_top_lerp.current
	limit_bottom = limit_bottom_lerp.current
