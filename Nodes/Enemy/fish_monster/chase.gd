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
	print(enemy.global_position.distance_to(target))
	if enemy.global_position.distance_to(target) > enemy.attack_range:
		enemy.velocity = enemy.global_position.direction_to(target) * move_speed
		enemy.move_and_slide()
	else:
		enemy.velocity = Vector2.ZERO
		enemy.move_and_slide()
		enemy.change_state(Global.enemy.ATTACK)
