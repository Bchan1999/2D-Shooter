extends Node2D

@onready var dialog_box: Control = $"../CanvasLayer/DialogBox"

func _ready():
	Global.dialogue.connect(show_dialog)
	
func show_dialog(dialog):
	Global.freeze_game.emit(true)
	dialog_box.visible = true
	
func disable_dialog():
	Global.freeze_game.emit(false)
	dialog_box.visible = false
