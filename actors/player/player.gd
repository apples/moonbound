extends KinematicBody2D

export(NodePath) var camera_path: NodePath
onready var camera_node: Camera2D = get_node_or_null(camera_path)

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

var room_areas = []

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


func _on_BodyArea_area_entered(area: Area2D):
	if area.is_in_group('room_area') and not area in room_areas:
		room_areas.push_back(area)
	_update_camera_area()


func _on_BodyArea_area_exited(area: Area2D):
	if area.is_in_group('room_area') and area in room_areas:
		room_areas.erase(area)
	_update_camera_area()

func _update_camera_area():
	if camera_node == null:
		return
	if room_areas.empty():
		return
	var limit_left = 10000000
	var limit_right = -10000000
	var limit_top = 10000000
	var limit_bottom = -10000000
	for area in room_areas:
		var shape_origin: Vector2 = area.shape_owner_get_transform(0).origin
		var shape: RectangleShape2D = area.shape_owner_get_shape(0, 0)
		var top_left = area.global_position + shape_origin - shape.extents
		var bottom_right = area.global_position + shape_origin + shape.extents
		limit_left = min(limit_left, top_left.x)
		limit_right = max(limit_right, bottom_right.x)
		limit_top = min(limit_top, top_left.y)
		limit_bottom = max(limit_bottom, bottom_right.y)
	camera_node.limit_left_lerp.target = limit_left
	camera_node.limit_right_lerp.target = limit_right
	camera_node.limit_top_lerp.target = limit_top
	camera_node.limit_bottom_lerp.target = limit_bottom
