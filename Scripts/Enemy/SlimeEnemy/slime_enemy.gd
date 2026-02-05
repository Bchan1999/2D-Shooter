extends CharacterBody2D

@export var anim : AnimationPlayer
@onready var MAX_HEALTH = 10
@onready var player
var health
var damage = 2

var current_state
var state_node

var history = []

func _ready() -> void:
	print("enemy scene" , get_tree().current_scene)
	health = MAX_HEALTH
	history = []
	history.append(Global.enemy.SPAWN)
	current_state = Global.enemy.SPAWN
	$Spawn.Enter()
	state_node = $Spawn
	
	#assert(player, "Slime Enemy: Player path is invalid/Player cannot be found")
	
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
		history = []
		history.append(current_state)
		$Idle.Enter()
		state_node = $Idle
	elif current_state == Global.enemy.HURT:
		history.append(current_state)
		$Hurt.Enter()
		state_node = $Hurt
	elif current_state == Global.enemy.DEATH:
		$Death.Enter()
		state_node = $Death
	elif current_state == Global.enemy.CHASE:
		history = []
		history.append(current_state)
		$Chase.Enter()
		state_node = $Chase
	elif current_state == Global.enemy.SPAWN:
		$Spawn.Enter()
		state_node = $Spawn

func take_damage(dmg):
	health = health - dmg
	health = clamp(health, 0, MAX_HEALTH)
	if health == 0:
		Global.enemy_kill.emit()
		change_state(Global.enemy.DEATH)
		
func get_dmg():
	return damage

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if area.has_method("get_dmg"):
			if current_state == Global.enemy.DEATH || current_state == Global.enemy.SPAWN:
				return
			else:
				change_state(Global.enemy.HURT)
				take_damage(area.get_dmg())
				
		assert(area.has_method("get_dmg"), "Bullet needs a get_dmg() method")
		
func get_player_chase() -> Vector2:
	return player.position
		
func _on_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		change_state(Global.enemy.CHASE)
		
func previous_state_change():
	history.pop_back()
	change_state(history.pop_front())
