extends Control

var resource = load("res://Dialogue/dialogue_test.dialogue")
@onready var dialogue_label: DialogueLabel = $"Control/TileMapLayer/DialogueLabel"
@onready var interact_ind: Sprite2D = $"Control/TileMapLayer/Interact_Ind"
@onready var control: Control = $Control

var dialog_state = false
var dialog_typing = false
var dialog_next_line = false
	
func _ready():	
	Global.dialogue.connect(show_dialog)
	self.visible = false
	interact_ind.visible = false
	#TODO receive dialog text from else where
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "test")
	dialogue_label.dialogue_line = dialogue_line
	print(dialogue_line)
	
func _process(delta:float):
	if dialog_state:
		if Input.is_action_just_pressed("interact"):
			if dialog_typing == true:
				pass
			else :
				print("disable please")
				disable_dialog()
	
func show_dialog(dialog):
	Global.freeze_game.emit(true)
	self.visible = true
	dialog_state = true
	type_out()
	
func type_out():
	dialogue_label.type_out()
	
func disable_dialog():
	Global.freeze_game.emit(false)
	self.visible = false
	dialog_state = false

func _on_dialogue_label_started_typing() -> void:
	dialog_typing = true

func _on_dialogue_label_finished_typing() -> void:
	print("testa")
	interact_ind.visible = true
	dialog_typing = false
