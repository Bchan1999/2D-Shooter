extends StaticBody2D

@onready var ind_interact: AnimatedSprite2D = $E_popup

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		print("Interact indicator")
		show_ind()
		Global.npc_interact.emit(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		print("Interact indicator")
		hide_ind()
		Global.npc_interact.emit(false)

func show_ind():
	ind_interact.visible = true

func hide_ind():
	ind_interact.visible = false
