extends Node2D

signal data(damage, effect)

var travelled_distance = 0


func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_area_2d_body_entered(body):
	queue_free()
	

func _on_data(damage, efect) -> void:
	var danage = damage
	var effect = efect
	emit_signal("data", danage, effect)
