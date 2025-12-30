extends Node2D

@onready var spawn: Marker2D = $"../Spawn"
@export var slime_scene : PackedScene

func _ready():
	print("TEST")
	#var slime = slime_scene.instantiate()
	#slime.position = spawn.global_position
	#get_tree().current_scene.add_child(slime)
		
func spawn_enemy():
	print("test slime")
	var slime = slime_scene.instantiate()
	get_parent().add_child(slime)
	return slime
		
func spawn_enemies(amount):
	print("Spawning enemies")
	var spawns = get_children()
	var i = 0
	while (i < amount):
		var slime = spawn_enemy()
		slime.position = spawns[i].global_position
		i = i + 1
	
	
