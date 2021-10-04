extends Control

func _ready():
	visible = false
	DebugState.connect("toggle_debug", self, "_on_DebugState_toggle_debug")

func _on_DebugState_toggle_debug(show_labels):
	visible = show_labels
