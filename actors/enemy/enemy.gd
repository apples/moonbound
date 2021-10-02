extends KinematicBody2D


var base_max_health = 10
var current_health = 10
var dead = false
var type = 0
var crypto_tribe = 0

#pick 6 from the following
var base_regen_rate = 1
var base_armor = 3
var base_move_speed = 50.0
var base_attack_power = 5
var base_attack_speed = 2
var base_ranged_attack_power = 3
var base_ranged_attack_speed = 3
var base_stamina = 20
var base_crit_chance = 5
var base_dodge_chance = 5
var base_attack_range = 20





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dead:
		_process_alive(delta)
	else:
		pass

func _process_alive(delta):
	var dir = Vector2(0, 0)
	var player = get_tree().get_nodes_in_group("player")[0]
	var vec = player.position - position
	dir = vec.normalized()
	move_and_slide(dir * base_move_speed)
