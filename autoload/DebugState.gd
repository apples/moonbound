extends Node

signal toggle_debug(show_labels)

var show_labels = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("toggle_debug"):
		show_labels = not show_labels
		emit_signal("toggle_debug", show_labels)
