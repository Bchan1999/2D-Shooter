extends Node2D

@onready var dialog_box: Control = $"../CanvasLayer/DialogBox"
var resource = load("res://Dialogue/dialogue_test.dialogue")

var dialog_state = false

func _ready():
	Global.dialogue.connect(show_dialog)
	dialog_box.visible = false
	
func _process(delta:float):
	if dialog_state:
		if Input.is_action_just_pressed("interact"):
			print("disable please")
			disable_dialog()
	
func show_dialog(dialog):
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "test")
	print(dialogue_line)
	pass
	#Global.freeze_game.emit(true)
	#dialog_box.visible = true
	#dialog_state = true
	
func disable_dialog():
	Global.freeze_game.emit(false)
	dialog_box.visible = false
	dialog_state = false
