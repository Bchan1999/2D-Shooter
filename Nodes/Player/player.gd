extends CharacterBody2D

@export var move_speed := 100
@export var acceleration := 500
@export var deceleration := 500
@export var anim_body : AnimationPlayer   # character sprite
@export var anim_gun : AnimationPlayer    # pistol only
@export var aim : Marker2D
@export var bullet_scene : PackedScene
@onready var gunshot: AudioStreamPlayer2D = $Gunshot
@onready var camera: Camera2D = $Camera2D
@onready var label: Label = $CanvasLayer/Label
@onready var diamond_amt_label: Label = $CanvasLayer/Diamond_Amt
@export var MAX_HEALTH = 10
@export var START_DIAMOND = 0

var health
var diamond_amt
var npc_interact = false
var change_gun = false
var move = false
var is_shooting := false
var current_aim_anim := ""

func _ready() -> void:
	health = MAX_HEALTH
	diamond_amt = START_DIAMOND
	Global.freeze_game.connect(stop_movement)

func stop_movement(is_frozen: bool):
	move = is_frozen

func _physics_process(delta: float) -> void:
	label.text = str("Health: ", health)
	diamond_amt_label.text = str(diamond_amt, " :")

	var dir = Input.get_vector("left", "right", "up", "down")

	if !move:
		if dir != Vector2.ZERO:
			velocity = velocity.move_toward(move_speed * dir, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

		move_and_slide()

		var mouse_pos = get_local_mouse_position()
		aim.global_rotation = lerp_angle(aim.global_rotation, atan2(mouse_pos.y, mouse_pos.x), 0.2)

		# --- Resolve direction suffix ---
		var suffix := get_aim_suffix()

		# --- anim_body: walk or idle, never interrupted by shooting ---
		if dir != Vector2.ZERO:
			anim_body.play("Run_With_Gun/" + suffix)
		else:
			anim_body.play("Idle_With_Gun/" + suffix)

		# --- anim_gun: direction idle, unless mid-shoot ---
		var gun_idle = "Gun/" + suffix
		if gun_idle != current_aim_anim:
			current_aim_anim = gun_idle
		if not is_shooting:
			anim_gun.play(current_aim_anim)

		if Input.is_action_just_pressed("shoot"):
			shoot()

func get_aim_suffix() -> String:
	var deg = aim.rotation_degrees
	if deg >= -22.5 and deg < 22.5:    return "side"        # your Gun/ anims use "side" not "side_right"
	elif deg >= 22.5 and deg < 67.5:   return "diagdown_right"
	elif deg >= 67.5 and deg < 112.5:  return "south"
	elif deg >= 112.5 and deg < 157.5: return "diagdown_left"
	elif deg >= 157.5 or deg < -157.5: return "side_left"
	elif deg >= -157.5 and deg < -112.5: return "diagup_left"
	elif deg >= -112.5 and deg < -67.5:  return "north"
	elif deg >= -67.5 and deg < -22.5:  return "diagup_right"
	else:
		return "error"
	

func shoot():
	is_shooting = true
	gunshot.play()
	camera.apply_shake()

	var bullet = bullet_scene.instantiate()
	bullet.position = aim.get_node('bullet_hole').global_position
	bullet.rotation = aim.global_rotation
	get_tree().current_scene.add_child(bullet)

	var shoot_anim = "Gun/shoot_" + get_aim_suffix()
	if anim_gun.has_animation(shoot_anim):
		anim_gun.play(shoot_anim)
		await anim_gun.animation_finished
	is_shooting = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("diamond"):
		diamond_interact()

func diamond_interact():
	diamond_amt += 1
