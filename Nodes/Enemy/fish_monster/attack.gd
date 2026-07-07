extends State
class_name FishAttack
@export var anim: AnimationPlayer
@export var enemy: CharacterBody2D
@export var attack_cooldown := 1.0  # seconds between hits

var _timer := 0.0

func Enter():
	_timer = 0.0
	_do_attack()

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	enemy.velocity = Vector2.ZERO
	enemy.move_and_slide()

	# if player walked out of range, go back to chasing
	if not enemy.player_in_attack_range():
		enemy.change_state(enemy.fish_state.CHASE)
		return

	_timer -= delta
	if _timer <= 0.0:
		_do_attack()

func _do_attack():
	_timer = attack_cooldown
	anim.play("attack")
	# deal damage to the player here
	if enemy.player and enemy.player.has_method("take_damage"):
		enemy.player.take_damage(enemy.get_dmg())
