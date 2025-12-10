extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		print("Hey player")
