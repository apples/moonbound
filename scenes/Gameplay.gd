extends Node2D

onready var plot_minimized = $CanvasLayer/PlotMinimized
onready var plots = $CanvasLayer/Plots

func _ready():
	plots.hide()


func _process(delta):
	if Input.is_action_just_pressed("toggle_plots"):
		plots.visible = not plots.visible
		plot_minimized.visible = not plot_minimized.visible
