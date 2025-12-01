extends State
class_name EnemyHurt

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var move_speed := 20.0

func Enter():
	anim.play("hurt")
