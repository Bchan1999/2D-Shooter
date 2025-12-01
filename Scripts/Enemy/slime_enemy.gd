extends CharacterBody2D

@export var anim : AnimationPlayer
@export var health = 10

enum {IDLE, HURT}
var current_state
var state_node
var change_state

func _ready() -> void:
	current_state = IDLE
	$Idle.Enter()
	state_node = $Idle
	
func _process(delta: float) -> void:
	if state_node:
		state_node.Update(delta)

func _physics_process(delta: float) -> void:
	if state_node:
		state_node.Physics_Update(delta)
		
	#TODO change this so that it triggers only when state is changed
	if change_state:
		print("change state")
		state_node.Exit()
		current_state = change_state
	
		if current_state == IDLE:
			$Idle.Enter()
			state_node = $Idle
		elif current_state == HURT:
			$Hurt.Enter()
			state_node = $Hurt
		
	move_and_slide()
	

func take_damage(dmg):
	health = health - dmg

func _on_hit_box_area_entered(area: Area2D) -> void:
	print(area)
	#TODO I dont think this class name is working
	if area.is_class("Bullet"):
		change_state = HURT
		take_damage(2)
		
