extends Node2D

var hub : PackedScene = preload("res://Scenes/hub.tscn")
var floor_one : PackedScene =  preload("res://Scenes/floor_one.tscn")
var dict : Dictionary
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	dict = {Global.scene.HUB : hub, Global.scene.F1 : floor_one}

func add_scene(scene_name : int):
	assert(dict.has(scene_name), "This scene does not exist in the Scene Manager")
	var new_scene = dict.get(scene_name)
	var scene_obj = new_scene.instantiate()
	get_tree().current_scene.add_child(scene_obj)
	get_tree().current_scene.move_child(scene_obj, 0)
	return scene_obj

func remove_scene(scene_name : NodePath):
	assert(get_node(scene_name), "Node does not exist in tree")
	get_node(scene_name).queue_free()
