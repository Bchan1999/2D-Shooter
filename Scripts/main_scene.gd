extends Node2D

# Called every frame. 'delta' is the elapsed atime since the previous frame.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # default behavior
		
