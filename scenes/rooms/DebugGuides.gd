tool
extends Node2D

export(bool) var show_guides = false setget _set_show_guides

var res = 0.25 * Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height"))

func _ready():
	pass # Replace with function body.


func _draw():
	if Engine.is_editor_hint():
		var root = get_tree().get_edited_scene_root()
		if show_guides and root.is_in_group('room'):
			draw_rect(Rect2(0, 0, res.x*4, res.y*4), Color.deeppink, false, 3)
			for i in range(1,4):
				draw_line(Vector2(res.x*i, 0), Vector2(res.x*i, res.y*4), Color.red, 2)
				draw_line(Vector2(0, res.y*i), Vector2(res.x*4, res.y*i), Color.red, 2)

func _set_show_guides(x):
	show_guides = x
	update()
