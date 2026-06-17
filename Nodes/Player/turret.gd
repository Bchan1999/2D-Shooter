extends CharacterBody2D

@export var aim : Marker2D

func _physics_process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	aim.global_rotation = lerp_angle(aim.global_rotation, atan2(mouse_pos.y, mouse_pos.x), 0.2)
	
	print(mouse_pos)
	
	
	
