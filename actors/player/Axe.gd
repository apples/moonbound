extends Area2D


var cooldown = 0

var swinging = false

func swing():
	if cooldown == 0 and not swinging:
		#$SfxAxe.play()
		show()
		$CollisionShape2D.disabled = false
		$PickaxeSprite.play()
		swinging = true


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$CollisionShape2D.disabled = true
	$PickaxeSprite.stop()


func _on_PickaxeSprite_animation_finished():
	hide()
	$CollisionShape2D.disabled = true
	$PickaxeSprite.stop()
	cooldown = .5
	swinging = false


func _on_Pickaxe_body_entered(body):
	if body.is_in_group("enemy"):
		#print("hit: " + body.name)
		body.get_hit(get_parent().attack_power)


func _process(delta):
	if cooldown > 0:
		cooldown -= delta
		if cooldown < 0:
			cooldown = 0
