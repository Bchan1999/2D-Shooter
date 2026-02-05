extends Camera2D

#@onready var player: CharacterBody2D = $"../Player"
#@export var randomStrength : float = 2.0
#@export var shakeFade : float = 30.0
#
#var rng = RandomNumberGenerator.new()
#var shake_strength : float = 0.0
#
#func _ready() -> void:
	#Global.enemy_kill.connect(enemy_killed)
	#
#func apply_shake():
	#shake_strength = randomStrength
	#
#func _process(delta: float) -> void:
	#global_position = player.position
	#if shake_strength > 0:
		#shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		#offset = randomOffset()
#
#func randomOffset() -> Vector2:
	#return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
#
#func enemy_killed():
	#apply_shake()
