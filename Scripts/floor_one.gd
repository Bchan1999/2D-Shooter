extends Node2D

@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var teleport: Teleport = $Teleport

enum {ROUND_1, ROUND_2}

var round_1_enemies = 3
var round_2_enemies = 5
var enemies_dead = 0
@onready var current_round = ROUND_1
var current_enemies
var final_round = false;

func _ready():
	print("ready floor one ")
	enemy_spawner.spawn_enemies(round_1_enemies)
	current_enemies = round_1_enemies
	Global.enemy_kill.connect(enemy_killed)

func _process(delta: float) -> void:
	if enemies_dead == current_enemies:
		enemies_dead = 0
		if final_round == true:
			print("end round")
			teleport.teleport_to_hub()
		else:
			next_round()
			
func enemy_killed():
	enemies_dead = enemies_dead + 1
	print(enemies_dead)
	print("final round:" , final_round)
	print("curr ene" , current_enemies)
	
func next_round():
	var next_round = current_round + 1
	if next_round == ROUND_2:
		start_round_2()
	
func start_round_2():
	final_round = true
	current_enemies = round_2_enemies
	enemy_spawner.spawn_enemies(round_2_enemies)
