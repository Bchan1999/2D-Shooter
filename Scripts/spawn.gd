extends State
class_name EnemySpawn

@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D

func Enter():
	anim.play("spawn")
	
	var timer := Timer.new()
	add_child(timer)
	
	timer.wait_time = 1.0
	
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	enemy.change_state(Global.enemy.IDLE)
