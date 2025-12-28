extends CharacterBody2D
@export var move_speed := 100
@export var acceleration := 500
@export var deceleration := 500
@export var anim_player : AnimationPlayer
@export var anim_gun : AnimationPlayer
@export var aim : Marker2D
@export var bullet_scene : PackedScene
@onready var label: Label = $Label

@export var MAX_HEALTH = 10
var health

var change_gun = false

func _ready() -> void:
	health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	label.text = str("Health: " , health)
	 
	var dir = Input.get_vector("left", "right", "up" , "down")
	
	if dir != Vector2.ZERO:
		var target_velocity = move_speed * dir
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
	move_and_slide()
	
	var mouse_pos = get_local_mouse_position()
	var rotate = atan2(mouse_pos.y, mouse_pos.x)
	aim.global_rotation = lerp_angle(aim.global_rotation, rotate, 0.2)
	
	if aim.rotation_degrees >= -22.5 and aim.rotation_degrees < 22.5:
		anim_gun.play("With_Gun/side_right")                  # Right
	elif aim.rotation_degrees >= 22.5 and aim.rotation_degrees < 67.5:
		anim_gun.play("With_Gun/diagdown_right")             # Down-right
	elif aim.rotation_degrees >= 67.5 and aim.rotation_degrees < 112.5:
		anim_gun.play("With_Gun/south")                        # Down
	elif aim.rotation_degrees >= 112.5 and aim.rotation_degrees < 157.5:
		anim_gun.play("With_Gun/diagdown_left")              # Down-left
	elif aim.rotation_degrees >= 157.5 or aim.rotation_degrees < -157.5:
		anim_gun.play("With_Gun/side_left")                   # Left
	elif aim.rotation_degrees >= -157.5 and aim.rotation_degrees < -112.5:
		anim_gun.play("With_Gun/diagup_left")                # Up-left
	elif aim.rotation_degrees >= -112.5 and aim.rotation_degrees < -67.5:
		anim_gun.play("With_Gun/north")                          # Up
	elif aim.rotation_degrees >= -67.5 and aim.rotation_degrees < -22.5:
		anim_gun.play("With_Gun/diagup_right")               # Up-right
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	move_and_slide()
	
func take_damage(dmg):
	health = health - dmg
	health = clamp(health, 0, MAX_HEALTH)
	
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	if health == 0:
		death()
	
func death():
	pass

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = aim.get_node('bullet_hole').global_position
	bullet.rotation = aim.global_rotation  # Use pivot's rotation, not player's
	get_tree().current_scene.add_child(bullet)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body enetered")
	if body.is_in_group("enemy"):
		print("enemy eneteed")
		if body.has_method("get_dmg"):
			print("took damagea")
			take_damage(body.get_dmg())
