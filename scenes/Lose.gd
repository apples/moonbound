extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$SFXLose.play()


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Gameplay.tscn")
