extends Area2D

@export var speed := 600
@export var  max_distance = 1000
@export var damage = 5

var start = Vector2.ZERO


func ready():
	start = position
	
func get_dmg():
	return damage

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
	var distance = $CollisionShape2D.position.distance_to(start)
	# Check if the distance exceeds the limit
	if distance > max_distance:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
