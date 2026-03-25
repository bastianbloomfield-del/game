extends Node2D

@export var daynight_cycle: float = 300.0 #= 5mins
@export var gradient_as: Gradient 

@export var daynight_state: float = 0.0:
	set(value):
		daynight_state = value
		$CanvasModulate.color = gradient_as.sample(value)

func _on_timer_timeout() -> void:
	daynight_state += 1.0 / daynight_cycle * $Timer.wait_time
	if daynight_state >= 1.0:
		daynight_state = 0.0
