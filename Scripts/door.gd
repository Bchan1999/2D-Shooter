extends Node2D
@onready var door_anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	door_anim.play("closed")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		door_anim.play("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		door_anim.play("closed")
