extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Floating")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body: ", body)
	if body.is_in_group("player"):
		self.queue_free()
