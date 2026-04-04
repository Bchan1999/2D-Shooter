extends Node2D
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@export var slime_enenmy: PackedScene

func _ready() -> void:
	enemy_spawner.spawn_enemies(slime_enenmy, 3)
