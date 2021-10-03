tool
extends Node2D

var is_current: bool = false setget _set_is_current

signal spawn
signal despawn

func _ready():
	pass

func _set_is_current(c: bool):
	if c == is_current:
		return
	is_current = c
	if is_current:
		emit_signal("spawn")
	else:
		emit_signal("despawn")
