extends State
class_name EnemyChase

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var move_speed := 20.0
	
	
func Enter():
	anim.play("idle")
	
func Physics_Update(delta: float):
	enemy.velocity = enemy.position.direction_to(enemy.get_player_chase()) * move_speed
	# look_at(target)
	if enemy.position.distance_to(enemy.get_player_chase()) > 10:
		enemy.move_and_slide()
