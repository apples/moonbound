extends Node2D

onready var plot_minimized = $CanvasLayer/RootControl/PlotMinimized
onready var plots = $CanvasLayer/RootControl/Plots

func _ready():
	plots.hide()
	$Music.play()


func _process(delta):
	if Input.is_action_just_pressed("toggle_plots"):
		plots.visible = not plots.visible
		plot_minimized.visible = not plot_minimized.visible
