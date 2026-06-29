extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var MAX_HEALTH = 10
var health
var stages := ["no_seed", "seed", "baby", "teen", "adult"]
var current := 0
@onready var progress_bar: ProgressBar = $ProgressBar

@export var interval := 2.0  # seconds between stages

func _ready() -> void:
	_play_all_stages()
	set_health()
	
func set_health():
	health = MAX_HEALTH
	progress_bar.max_value = MAX_HEALTH
	progress_bar.value = health
	pass
	
func update_health_bar():
	progress_bar.value = health
	pass

func _play_all_stages() -> void:
	anim.play(stages[current])

	# adult is final — let it loop/hold forever
	if current >= stages.size() - 1:
		return

	await get_tree().create_timer(interval).timeout
	current += 1
	_play_all_stages()
	
func take_damage(dmg):
	health = health - dmg
	health = clamp(health, 0, MAX_HEALTH)
	update_health_bar()
	pass
