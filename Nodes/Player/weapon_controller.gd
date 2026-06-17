extends Node2D
@onready var pistol: AnimatedSprite2D = $Pistol

func set_visble(boolean):
	pistol.visible = boolean
