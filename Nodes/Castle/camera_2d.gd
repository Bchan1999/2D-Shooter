extends Camera2D

@export var shake_strength: float = 1.0
@export var shake_fade: float = 5.0

var _current_strength: float = 0.0
var _rng := RandomNumberGenerator.new()

func apply_shake(strength: float = -1.0) -> void:
	_current_strength = strength if strength > 0.0 else shake_strength

func _process(delta: float) -> void:
	if _current_strength > 0.0:
		_current_strength = lerpf(_current_strength, 0.0, shake_fade * delta)
		offset = Vector2(
			_rng.randf_range(-_current_strength, _current_strength),
			_rng.randf_range(-_current_strength, _current_strength)
		)
	else:
		offset = Vector2.ZERO
