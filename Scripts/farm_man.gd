extends StaticBody2D

@onready var ind_interact: AnimatedSprite2D = $E_popup
@onready var interaction_area: InteractionArea = $InteractionArea

var text_box = 1

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	pass
	
func _on_interact():
	Global.dialogue.emit(text_box)
	print("suck my dick please")

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("body: ", body)
	#if body.is_in_group("player"):
		#print("Interact indicator")
		#show_ind()
		#Global.npc_interact.emit(true)
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("body: ", body)
	#if body.is_in_group("player"):
		#print("Interact indicator")
		#hide_ind()
		#Global.npc_interact.emit(false)
#
#func show_ind():
	#ind_interact.visible = true
#
#func hide_ind():
	#ind_interact.visible = false
