extends KinematicBody2D

export(NodePath) var camera_path: NodePath
onready var camera_node: Camera2D = get_node_or_null(camera_path)

var invuln = false
var dead = false
var base_max_health = 10
var current_health = 10

#pick 6 from the following
var regen_rate = 1
var armor = 3
#var base_move_speed = 50
var attack_power = 5
var attack_speed = 2
var ranged_attack_power = 3
var ranged_attack_speed = 3
var stamina = 20
var crit_chance = 5
var dodge_chance = 5
var attack_range = 20

const base_move_speed = 100.0

enum { DIR_N, DIR_S, DIR_E, DIR_W }
var facing = DIR_S

var room_areas = []
var current_room_area = null

onready var anim_tree = $AnimationTree
onready var anim_tree_playback = anim_tree["parameters/playback"]
onready var anim_tree_normal_playback = anim_tree["parameters/normal/state_machine/playback"]

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_tree_playback.start("normal")
	anim_tree_normal_playback.start("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_camera_area()
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
		
	if(facing == DIR_W):
		$Sprite.flip_h = true
	else:
		if(facing == DIR_E):
			$Sprite.flip_h = false
		
	match facing:
		DIR_S:
			anim_tree_normal_playback.travel("walk_S")
		DIR_N:
			anim_tree_normal_playback.travel("walk_N")
		DIR_E:
			anim_tree_normal_playback.travel("walk_E")
		DIR_W:
			anim_tree_normal_playback.travel("walk_W")
	
	if dir.length_squared() == 0:
		anim_tree_normal_playback.travel("default")
	
	if Input.is_action_just_pressed("attack") and not $Pickaxe.swinging and $Pickaxe.cooldown <= 0:
		match facing:
			DIR_N:
				$Pickaxe.rotation_degrees = 180
			DIR_S:
				$Pickaxe.rotation_degrees = 0
			DIR_E:
				$Pickaxe.rotation_degrees = 180 + 90
			DIR_W:
				$Pickaxe.rotation_degrees = 90#probably should flip sprite here
		$Pickaxe.swing()


func _on_InvulnTimer_timeout():
	invuln = false
	$Sprite.modulate = Color(1, 1, 1)

func get_hit():
	if not dead and not invuln:
		$Sprite.modulate = Color(1, 0.5, 0.5)
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
	$Sprite.rotation_degrees = 90
	#anim_tree_playback.travel("normal")
	#anim_tree_normal_playback.travel("default")
	emit_signal("on_death", self)


func _on_BodyArea_area_entered(area: Area2D):
	if area.is_in_group('room_area') and not area in room_areas:
		room_areas.push_back(area)


func _on_BodyArea_area_exited(area: Area2D):
	if area.is_in_group('room_area') and area in room_areas:
		room_areas.erase(area)
	_update_camera_area()

func _update_camera_area():
	if camera_node == null:
		return
	if room_areas.empty():
		return
	for area in room_areas:
		var shape_origin: Vector2 = area.shape_owner_get_transform(0).origin
		var shape: RectangleShape2D = area.shape_owner_get_shape(0, 0)
		var rect = Rect2(
			area.global_position + shape_origin - shape.extents,
			shape.extents * 2.0)
		if rect.has_point(self.global_position):
			if current_room_area == area:
				return
			if current_room_area != null:
				current_room_area.set_current(false)
			current_room_area = area
			current_room_area.set_current(true)
			camera_node.limit_left_lerp.target = rect.position.x
			camera_node.limit_right_lerp.target = rect.position.x + rect.size.x
			camera_node.limit_top_lerp.target = rect.position.y
			camera_node.limit_bottom_lerp.target = rect.position.y + rect.size.y
			return
