extends KinematicBody2D

export(MarketType.Types) var market_type
export(float) var base_move_speed = 50.0
export(float) var base_attack_power = 5
export(float) var base_attack_speed = 2

var base_max_health = 10
var current_health = 10
var dead = false
var type = 0
var crypto_tribe = 0
var facing_right = false

var player = null

var current_move_speed = base_move_speed
var current_attack_power = base_attack_power
var current_attack_speed = base_attack_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = get_tree().get_nodes_in_group("player")
	player = players[0] if players.size() > 0 else null
	$AnimatedSprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead:
		_process_alive(delta)
	else:
		pass

func _process_alive(delta):
	# Update stats based on market
	var strength_market = Market.motions[MarketType.Types.STRENGTH].current / 100.0
	if market_type != MarketType.Types.STRENGTH:
		strength_market = 1.0 + (strength_market - 1.0) / 2.0
	var speed_market = Market.motions[MarketType.Types.SPEED].current / 100.0
	if market_type != MarketType.Types.SPEED:
		speed_market = 1.0 + (speed_market - 1.0) / 2.0
	var atkspeed_market = Market.motions[MarketType.Types.ATKSPEED].current / 100.0
	if market_type != MarketType.Types.ATKSPEED:
		atkspeed_market = 1.0 + (atkspeed_market - 1.0) / 2.0
	
	current_attack_power = int(base_attack_power * strength_market)
	current_attack_speed = int(base_attack_speed * atkspeed_market)
	current_move_speed = int(base_move_speed * speed_market)
	
	$DebugLabels/Attack.text = str(current_attack_power)
	$DebugLabels/AttackSpeed.text = str(current_attack_speed)
	$DebugLabels/MoveSpeed.text = str(current_move_speed)
	
	var dir = Vector2(0, 0)
	var vec = player.position - global_position
	_process_anim(vec, dir)
	
	if vec.length() < 16 * 5:
		dir = vec.normalized()
		move_and_slide(dir * current_move_speed)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name == "Player"):
			$AnimatedSprite.play("attack")
			player.get_hit(current_attack_power)

func _process_anim(vec, dir):
	if vec.length() < 16 * 5 && vec.length() > 3 * 15:
		$AnimatedSprite.play("walk")
	
	if vec.length() <= 1 * 15:
		$AnimatedSprite.play("attack")
		
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
		$AnimatedSprite.play("idle")

func get_hit(damage, hitDir = Vector2(0, 0)):
	$AnimatedSprite.modulate = Color(1, 0.5, 0.5)
	if not dead:
		if current_health > 0:
			current_health -= damage
			$InvulnTimer.start()
		if current_health <= 0:
			dead = true
			player.gold = player.gold + 1
			$DeadTimer.start()
			$CollisionPolygon2D.set_deferred("disabled", true)
			$AnimatedSprite.rotation_degrees = 90
			$AnimatedSprite.stop()

func _on_DeadTimer_timeout():
	queue_free()


func _on_InvulnTimer_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1)
