extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var room: Node = null

func _on_Area2D_body_entered(body):
	room = $Room1.create_instance()



func _on_Area2D_body_exited(body):
	if room != null:
		room.queue_free()
