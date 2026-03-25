extends Node2D

signal data(damage)

@onready var ani: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


#add it to take damage in and out

func _on_melee_stab_data(damage: Variant) -> void:
	if not timer.is_stopped():
		return
	
	emit_signal("data", damage)
	ani.play("attack")
	timer.start()
