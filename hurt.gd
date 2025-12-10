extends State
class_name EnemyHurt

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var move_speed := 20.0

func Enter():
	anim.play("hurt")
	
func Update(delta: float) -> void:
	#TODO go to previous state that was playing
	if !anim.is_playing():
		enemy.change_state(Global.enemy.CHASE)
	
	

	
