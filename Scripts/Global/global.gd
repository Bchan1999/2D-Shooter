extends Node

enum enemy {IDLE, HURT, DEATH, CHASE, SPAWN}

enum scene {HUB, FL_ONE}

signal enemy_kill

signal npc_interact(toggle)
