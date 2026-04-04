extends Node2D
#  Parent node controls the trigger of the spawnwer
class_name EnemySpawner

@export var slime_scene : PackedScene

func spawn_enemy(scene: PackedScene) -> Node2D:
	var enemy = scene.instantiate()
	get_parent().add_child(enemy)
	return enemy

func spawn_enemies(scene: PackedScene, amount: int) -> Array:
	var spawned = []
	var spawn_points = get_children()
	if spawn_points.is_empty():
		return spawned
	for i in amount:
		var enemy = spawn_enemy(scene)
		var point = spawn_points[i % spawn_points.size()]
		enemy.global_position = point.global_position
	return spawned
	
