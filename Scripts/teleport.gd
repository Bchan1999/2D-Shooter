extends Node2D
class_name Teleport

@export var target_spawn : String

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		teleport_to_target(body)
		
func teleport_to_target(body):	
	var target_level = SceneManager.add_scene(Global.scene.FL_ONE)
	SceneManager.remove_scene(get_parent().get_path())
	body.position = target_level.get_node(target_spawn).global_position
	
func teleport_to_hub(player):
	var target_level = SceneManager.add_scene(Global.scene.HUB)
	SceneManager.remove_scene(get_parent().get_path())
	player.position = target_level.get_node(target_spawn).global_position
