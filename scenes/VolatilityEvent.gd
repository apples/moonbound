extends Timer

export(NodePath) var warning_path: NodePath
onready var warning: Control = get_node(warning_path)

var rng = RandomNumberGenerator.new()

var volatile: bool = false

func _ready():
	start(rng.randf_range(10.0, 15.0))
	warning.hide()

func _on_VolatilityEvent_timeout():
	volatile = not volatile
	for mt in Market.motions:
		var motion = Market.motions[mt]
		if volatile:
			motion.volatility = 0.8
		else:
			motion.volatility = Market.initial_volatility
	if volatile:
		start(rng.randf_range(5.0, 10.0))
		warning.show()
	else:
		start(rng.randf_range(10.0, 15.0))
		warning.hide()
