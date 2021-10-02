extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base_move_speed = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Vector2(0, 0)
	var player = get_tree().get_nodes_in_group("player")[0]
	var vec = player.position - position
	dir = vec.normalized()
	move_and_slide(dir * base_move_speed)
#	pass
