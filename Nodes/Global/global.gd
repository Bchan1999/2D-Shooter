extends Node

enum enemy {IDLE, HURT, DEATH, CHASE, SPAWN, ATTACK}

enum scene {HUB, F1 , HUB_F1_DONE}

enum npc {FARM}

signal enemy_kill

signal npc_interact(toggle)

signal dialogue(dia)

signal freeze_game(is_frozen: bool)

@onready var scene_state = scene.HUB

var _is_game_frozen: bool = false :
	set(value):
		if _is_game_frozen == value:
			return
		_is_game_frozen = value
		freeze_game.emit(_is_game_frozen)   # auto-emit when changed
		# Optional: also sync Godot's built-in pause
		# get_tree().paused = is_game_frozen

# Optional helper methods (very convenient)
func _freeze() -> void:
	_is_game_frozen = true

func _unfreeze() -> void:
	_is_game_frozen = false

func toggle_freeze() -> void:
	_is_game_frozen = !_is_game_frozen
