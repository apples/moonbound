tool
extends Node2D

export(bool) var show_guides = false setget _set_show_guides

func _ready():
	pass # Replace with function body.


func _draw():
	if Engine.is_editor_hint():
		if show_guides:
			draw_rect(Rect2(0, 0, 256*4, 150*4), Color.deeppink, false, 3)
			for i in range(1,4):
				draw_line(Vector2(256*i, 0), Vector2(256*i, 150*4), Color.red, 2)
				draw_line(Vector2(0, 150*i), Vector2(256*4, 150*i), Color.red, 2)

func _set_show_guides(x):
	show_guides = x
	update()
