tool
extends Container

export(MarketType.Types) var market_type
export(Color) var background_color = Color('#805000ff') setget _set_background_color

onready var motion: GeomBrownMotion = Market.motions[market_type]

func _ready():
	if background_color != null:
		$Background.color = background_color
	if Engine.is_editor_hint():
		set_process(false)

func _process(delta):
	if Engine.is_editor_hint():
		set_process(false)
		return
	_update_points()
	_update_labels()

func _update_points():
	var size = $Background.rect_size
	var points = $Line2D.points
	points.resize(motion.history.size())
	for i in range(motion.history.size()):
		points[i] = size * Vector2(
			i / float(motion.history.size()),
			1.0 - motion.history[i] / motion.history_max)
	$Line2D.points = points

func _update_labels():
	$Labels/MaxValueLabel.text = str(motion.history_max)
	$Labels/CurrentValueLabel.text = str(motion.current)

func _set_background_color(c: Color):
	background_color = c
	if background_color != null:
		$Background.color = background_color
