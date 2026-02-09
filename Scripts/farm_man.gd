extends StaticBody2D

@onready var ind_interact: AnimatedSprite2D = $E_popup
@onready var interaction_area: InteractionArea = $InteractionArea
@export var dialog_data : Resource

var dialog
var text_box = 1

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	if dialog_data is JSON:  # If using JSON path
		var json = JSON.new()
		#dialog = json.parse_string(dialog_data)  # Now a Dictionary
		print("this is dialog: ", dialog)
	
func _on_interact():
	Global.dialogue.emit(text_box)
	print("hello im a farm man")

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
