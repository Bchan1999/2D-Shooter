extends State
@export var anim : AnimationPlayer
@export var enemy: CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var move_speed := 20.0
@export var flash_duration := 0.2

var _timer := 0.0

func Enter():
	sprite.modulate = Color(1, 0, 0, 1)  # red tint
	_timer = flash_duration

func Update(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		sprite.modulate = Color(1, 1, 1, 1)  # remove tint
		enemy.previous_state_change()
