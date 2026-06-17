extends Node2D

signal card_selected(card_type: String)

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var green_tile_top: Sprite2D = $green_tile_top
@onready var top_tile: Area2D = $base_tile/Top_tile

enum card_select {LEFT, MIDDLE, RIGHT}
var current_card = -1
var confirm_ui: CanvasLayer

func _ready() -> void:
	top_tile.input_event.connect(_on_top_tile_input_event)
	_build_confirm_ui()

func _build_confirm_ui() -> void:
	confirm_ui = CanvasLayer.new()
	add_child(confirm_ui)

	var vbox = VBoxContainer.new()
	vbox.position = Vector2(185, 155)
	confirm_ui.add_child(vbox)

	var label = Label.new()
	label.text = "Place this tile?"
	vbox.add_child(label)

	var button = Button.new()
	button.text = "Confirm"
	button.pressed.connect(_on_confirm_pressed)
	vbox.add_child(button)

	confirm_ui.visible = false

func show_ui() -> void:
	visible = true
	current_card = -1
	anim.play("RESET")
	green_tile_top.visible = false
	confirm_ui.visible = false

func hide_ui() -> void:
	visible = false
	confirm_ui.visible = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("shoot"):
		if current_card == card_select.MIDDLE:
			anim.play_backwards("green_card_select")
			current_card = -1
			green_tile_top.visible = false
			confirm_ui.visible = false
		else:
			anim.play("green_card_select")
			current_card = card_select.MIDDLE

func _on_top_tile_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("shoot") and current_card == card_select.MIDDLE:
		green_tile_top.visible = true
		confirm_ui.visible = true

func _on_confirm_pressed() -> void:
	card_selected.emit("slime")

func _on_area_2d_mouse_entered() -> void:
	pass

func _on_area_2d_mouse_exited() -> void:
	pass
