extends Node

enum enemy {IDLE, HURT, DEATH, CHASE, SPAWN}

enum scene {HUB, F1 , HUB_F1_DONE}

enum npc {FARM}

signal enemy_kill

signal npc_interact(toggle)

signal dialogue(dia)

signal freeze_game(is_frozen: bool)

@onready var scene_state = scene.HUB

var is_game_frozen: bool = false :
	set(value):
		if is_game_frozen == value:
			return
		is_game_frozen = value
		freeze_game.emit(is_game_frozen)   # auto-emit when changed
		# Optional: also sync Godot's built-in pause
		# get_tree().paused = is_game_frozen

# Optional helper methods (very convenient)
func freeze() -> void:
	is_game_frozen = true

func unfreeze() -> void:
	is_game_frozen = false

func toggle_freeze() -> void:
	is_game_frozen = !is_game_frozen
