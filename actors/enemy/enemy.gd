extends KinematicBody2D


var base_max_health = 10
var current_health = 10
var dead = false
var type = 0
var crypto_tribe = 0
var facing_right = false

#pick 6 from the following
var base_regen_rate = 1
var base_armor = 3
var base_move_speed = 50.0#0
var base_attack_power = 5
var base_attack_speed = 2
var base_ranged_attack_power = 3
var base_ranged_attack_speed = 3
var base_stamina = 20
var base_crit_chance = 5
var base_dodge_chance = 5
var base_attack_range = 20

var player = null



# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	$AnimatedSprite.play("run")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dead:
		_process_alive(delta)
	else:
		pass

func _process_alive(delta):
	if not dead:
		var dir = Vector2(0, 0)
		var vec = player.position - global_position
		
		if vec.length() < 16 * 5:
			dir = vec.normalized()
			if(dir.x > 0):
				if(!facing_right):
					facing_right = true
					$AnimatedSprite.flip_h = true
			else:
				if(facing_right):
					facing_right = false
					$AnimatedSprite.flip_h = false
			
			if !$AnimatedSprite.is_playing():
				$AnimatedSprite.play("run")
		elif $AnimatedSprite.is_playing():
			$AnimatedSprite.stop()
		
		move_and_slide(dir * base_move_speed)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if(collision.collider.name == "Player"):
				player.get_hit()

func get_hit(damage, hitDir = Vector2(0, 0)):
	$AnimatedSprite.modulate = Color(1, 0.5, 0.5)
	if not dead:
		if current_health > 0:
			current_health -= damage
			$InvulnTimer.start()
		if current_health <= 0:
			dead = true
			$DeadTimer.start()
			$CollisionPolygon2D.set_deferred("disabled", true)
			$AnimatedSprite.rotation_degrees = 90
			$AnimatedSprite.stop()
			#$AnimatedSprite.stop()

func _on_DeadTimer_timeout():
	queue_free()


func _on_InvulnTimer_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1)
