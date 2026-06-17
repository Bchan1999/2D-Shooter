extends State
class_name FishChase

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var move_speed := 20.0


func Enter():
	anim.play("chase")

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	var target = enemy.get_player_chase()
	if enemy.global_position.distance_to(target) > 10:
		enemy.velocity = enemy.global_position.direction_to(target) * move_speed
	else:
		enemy.velocity = Vector2.ZERO
		
	enemy.move_and_slide()
