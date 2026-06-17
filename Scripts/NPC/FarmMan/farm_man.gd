extends StaticBody2D

@onready var ind_interact: AnimatedSprite2D = $E_popup
@onready var interaction_area: InteractionArea = $InteractionArea
@export var dialog_data : Resource

@export_category("NPC State")
@export var interactions = 0
@onready var area_interact: CollisionShape2D = $InteractionArea/CollisionShape2D

var hub_dia = load("res://Dialogue/farmman_hub_1.dialogue")

var dialog
var text_box = 1

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	area_interact.disabled = true
	Global.dialogue.emit(text_box)
	print("hello im a farm man")
	interactions=+ 1
	
func return_dialogue():
	var interact_template = "interact_"
	var title = interact_template + interactions
	return await DialogueManager.get_next_dialogue_line(hub_dia, title)
	
func reset_local_state():
	interactions = 0
