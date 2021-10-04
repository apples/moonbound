extends Node2D

export(String, FILE, "*.tscn") var actor_scene setget _set_actor_scene
export(float) var delay = 1.5

onready var actor_container = get_parent()

var actor_node: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.hide()
	actor_container.connect("spawn", self, "_on_actor_container_spawn")
	actor_container.connect("despawn", self, "_on_actor_container_despawn")

func _set_actor_scene(s: String):
	if typeof(s) == TYPE_STRING and s.get_extension() == "tscn":
		var d = Directory.new()
		if d.file_exists(s):
			actor_scene = s

func _on_actor_container_spawn():
	if actor_node != null:
		actor_node.queue_free()
	$Timer.start(delay)
	$AnimatedSprite.show()

func _on_actor_tree_exited():
	actor_node = null

func _on_actor_container_despawn():
	$Timer.stop()
	if actor_node != null:
		actor_node.disconnect("tree_exited", self, "_on_actor_tree_exited")
		actor_node.queue_free()
		actor_node = null


func _on_Timer_timeout():
	$Timer.stop()
	$AnimatedSprite.hide()
	actor_node = load(actor_scene).instance()
	actor_node.position = self.position
	actor_node.connect("tree_exited", self, "_on_actor_tree_exited")
	actor_container.add_child(actor_node)
