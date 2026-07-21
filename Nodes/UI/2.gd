extends Control
@onready var highlight: Sprite2D = $"highlight"

func highlight_box():
	highlight.visible = true

func unhighlight_box():
	highlight.visible = false
