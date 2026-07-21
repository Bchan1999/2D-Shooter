extends Control
@onready var box_spawn: Marker2D = $Box_spawn

@export var box_scene : PackedScene
var current_box : InvBox
var list_of_boxes : Array
var current_index := 0

@onready var item_test_hoe = preload("res://tres/UI/hoe.tres")
@onready var item_test_gun = preload("res://tres/UI/gun.tres")

func _ready():
	var x = 0
	var x_pos = box_spawn.global_position.x
	while (x < 9):
		var box : Control = box_scene.instantiate()
		var pos : Vector2 = Vector2(x_pos, box_spawn.global_position.y)
		if (box is InvBox):
			list_of_boxes.append(box)
			
		box.global_position = pos
		self.add_child(box)
		x = 1 + x
		x_pos = x_pos + 17
	current_box = list_of_boxes.get(0)
	
	print("Length of boxes:" , list_of_boxes.size())
	print(list_of_boxes)
	
	list_of_boxes.get(0).set_item(item_test_hoe)
	list_of_boxes.get(1).set_item(item_test_gun)



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_selection(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_selection(-1)

func change_selection(dir: int) -> void:
	list_of_boxes[current_index].unhighlight_box()
	current_index = wrapi(current_index + dir, 0, list_of_boxes.size())
	list_of_boxes[current_index].highlight_box()
	
