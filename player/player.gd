extends KinematicBody2D

var invuln = false
var dead = false
var sleeping = false

const base_move_speed = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		dir.x += 1.0
	if Input.is_action_pressed("move_down"):
		dir.y += 1.0
	if Input.is_action_pressed("move_up"):
		dir.y -= 1.0
		
	var move_speed = 0.0 if dir.length_squared() == 0 else 1.0
	
	move_and_slide(dir * move_speed * base_move_speed)
		
	pass
