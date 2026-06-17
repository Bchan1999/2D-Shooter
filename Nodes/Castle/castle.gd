extends CharacterBody2D

@onready var aim: Marker2D = $Aim
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@export var bullet_scene : PackedScene
@onready var gunshot: AudioStreamPlayer2D = $Gunshot


func _physics_process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	aim.global_rotation = lerp_angle(aim.global_rotation, atan2(mouse_pos.y, mouse_pos.x), 0.2)

	# --- Resolve direction suffix ---
	var suffix := get_aim_suffix()

	anim.play(suffix)

	if Input.is_action_just_pressed("shoot"):
		shoot()

func get_aim_suffix() -> String:
	var deg = aim.rotation_degrees
	if deg >= -22.5 and deg < 22.5:    return "right"        # your Gun/ anims use "side" not "side_right"
	elif deg >= 22.5 and deg < 67.5:   return "right_down"
	elif deg >= 67.5 and deg < 112.5:  return "down"
	elif deg >= 112.5 and deg < 157.5: return "left_down"
	elif deg >= 157.5 or deg < -157.5: return "left"
	elif deg >= -157.5 and deg < -112.5: return "left_up"
	elif deg >= -112.5 and deg < -67.5:  return "up"
	elif deg >= -67.5 and deg < -22.5:  return "right_up"
	else:
		return "error"

func shoot():
	gunshot.play()
	camera.apply_shake()

	var bullet = bullet_scene.instantiate()
	bullet.position = aim.get_node('bullet_hole').global_position
	bullet.rotation = aim.global_rotation
	get_tree().current_scene.add_child(bullet)
