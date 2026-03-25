extends Node2D

signal data(damage)

var travelled_distance = 0


func _physics_process(delta):
	print("ccccccccccccccccccccccccccc")
	const SPEED = 10
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_area_2d_body_entered(body):
	queue_free()
	

func _on_data(damage) -> void:
	var danage = damage
	emit_signal("data", danage)
