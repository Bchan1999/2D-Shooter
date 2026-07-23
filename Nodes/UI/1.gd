extends Control
class_name InvBox

@onready var highlight: Sprite2D = $"highlight"
var current_item

func _ready() -> void:
	unhighlight_box()
	

func highlight_box():
	highlight.visible = true

func unhighlight_box():
	highlight.visible = false

func set_item(item):
	var icon : Sprite2D = Sprite2D.new()
	icon.texture = item.icon
	#icon.global_position = pos_ref.global_position
	self.add_child(icon)
	current_item = item
	
func get_item() -> ItemData:
	return current_item
