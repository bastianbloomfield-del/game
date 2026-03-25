extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("player")
var speed: float = 10

var chase: bool = false

func _physics_process(delta: float) -> void:
	if chase:
		var dir = (player_node.global_position-global_position).normalized()
		velocity = lerp(velocity, dir * speed, 8.5*delta)
		move_and_slide()



func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		chase = true
	
func _on_exit_area_body_exited(body: Node2D) -> void:
	if body == player_node:
		chase = false
	

func take_damage(damage):
	print("waaa")
