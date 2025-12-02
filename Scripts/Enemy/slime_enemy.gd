extends CharacterBody2D

@export var anim : AnimationPlayer
@export var MAX_HEALTH = 10
var health

var current_state
var state_node

func _ready() -> void:
	health = MAX_HEALTH
	current_state = Global.enemy.IDLE
	$Idle.Enter()
	state_node = $Idle
	
func _process(delta: float) -> void:
	if state_node:
		state_node.Update(delta)

func _physics_process(delta: float) -> void:
	if state_node:
		state_node.Physics_Update(delta)
		
	move_and_slide()
	
func change_state(new_state):
	if new_state == current_state:
		return
	else:
		current_state = new_state
	
	state_node.Exit()

	if current_state == Global.enemy.IDLE:
		$Idle.Enter()
		state_node = $Idle
	elif current_state == Global.enemy.HURT:
		$Hurt.Enter()
		state_node = $Hurt
	elif current_state == Global.enemy.DEATH:
		$Death.Enter()
		state_node = $Death

func take_damage(dmg):
	health = health - dmg
	health = clamp(health, 0, MAX_HEALTH)
	if health == 0:
		change_state(Global.enemy.DEATH)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if area.has_method("get_dmg"):
			if current_state == Global.enemy.HURT || current_state == Global.enemy.DEATH:
				return
			else:
				change_state(Global.enemy.HURT)
				take_damage(area.get_dmg())
				
		assert(area.has_method("get_dmg"), "Bullet needs a get_dmg() method")
		
