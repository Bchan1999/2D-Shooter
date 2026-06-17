extends State

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var move_speed := 20.0

func Enter():
	anim.play("death")
	
func Update(delta: float) -> void:
	if !anim.is_playing():
		enemy.queue_free()
