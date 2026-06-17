extends Node2D
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@export var fish_monster: PackedScene

func _ready() -> void:
	enemy_spawner.spawn_enemies(fish_monster, 1)
