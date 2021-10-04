tool
extends Container

signal buy(plot)
signal sell(plot)

export(MarketType.Types) var market_type
export(Color) var background_color = Color('#805000ff') setget _set_background_color

var stat_value: int setget _set_stat_value

var motion: GeomBrownMotion

var price: int = 10

func _ready():
	if background_color != null:
		$Background.color = background_color
	$Shop/Grid/Label.text = MarketType.Types.keys()[market_type]
	if Engine.is_editor_hint():
		set_process(false)
		return
	motion = Market.motions[market_type]

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
			1.0 - motion.history[i] / 200.0)
	$Line2D.points = points

func _update_labels():
	$Labels/CurrentValueLabel.text = str(int(motion.current))
	
	price = int(motion.current / 10)
	$Shop/Grid/BuyButtonContainer/BuyButton.text = "Buy (" + str(price) + ")"

func _set_background_color(c: Color):
	background_color = c
	if background_color != null:
		$Background.color = background_color


func _on_SellButton_pressed():
	emit_signal("sell", self)


func _on_BuyButton_pressed():
	emit_signal("buy", self)

func _set_stat_value(v: int):
	stat_value = v
	$Shop/Grid/StatVals/CurrentStatLabel.text = str(v)
