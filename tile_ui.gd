extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

enum card_select {LEFT, MIDDLE, RIGHT}
var current_card = -1
var mouse_on_card = false
		
func deselect_middle():
	anim.play_backwards("green_card_select")
	
func select_middle():
	anim.play("green_card_select")
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("shoot"):
		if current_card == card_select.MIDDLE:
			deselect_middle()
			current_card = -1 
		else:
			select_middle()
			current_card = card_select.MIDDLE
