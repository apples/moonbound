extends KinematicBody2D

var invuln = false
var dead = false
var base_max_health = 10
var current_health = 10

#pick 6 from the following
var base_regen_rate = 1
var base_armor = 3
#var base_move_speed = 50
var base_attack_power = 5
var base_attack_speed = 2
var base_ranged_attack_power = 3
var base_ranged_attack_speed = 3
var base_stamina = 20
var base_crit_chance = 5
var base_dodge_chance = 5
var base_attack_range = 20

const base_move_speed = 100.0

enum { DIR_N, DIR_S, DIR_E, DIR_W }
var facing = DIR_S

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
	
	if dir.x < 0:
		facing = DIR_W
	if dir.x > 0:
		facing = DIR_E
	if dir.y < 0:
		facing = DIR_N
	if dir.y > 0:
		facing = DIR_S
		
#	match facing:
#		DIR_S:
#			anim_tree_normal_playback.travel("walk_S")
#		DIR_N:
#			anim_tree_normal_playback.travel("walk_N")
#		DIR_E:
#			anim_tree_normal_playback.travel("walk_E")
#		DIR_W:
#			anim_tree_normal_playback.travel("walk_W")
	
	if Input.is_action_just_pressed("attack") and not $Axe.swinging and $Axe.cooldown <= 0:
		match facing:
			DIR_N:
				$Axe.rotation_degrees = 180
			DIR_S:
				$Axe.rotation_degrees = 0
			DIR_E:
				$Axe.rotation_degrees = 180 + 90
			DIR_W:
				$Axe.rotation_degrees = 90
		$Axe.swing()


func _on_InvulnTimer_timeout():
	invuln = false

func get_hit():
	if not dead and not invuln:
		current_health -= 1
		if current_health == 0:
			be_dead()
			#$SfxLose.play()
		else:
			invuln = true
			$InvulnTimer.start()
			#$SfxHurt.play()

func be_dead():
	dead = true
	#$AnimatedSprite.rotation_degrees = 90
	#anim_tree_playback.travel("normal")
	#anim_tree_normal_playback.travel("default")
	emit_signal("on_death", self)
