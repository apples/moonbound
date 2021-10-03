extends YSort

signal spawn
signal despawn

func _ready():
	pass

func _on_RoomBase_spawn():
	emit_signal("spawn")

func _on_RoomBase_despawn():
	emit_signal("despawn")
