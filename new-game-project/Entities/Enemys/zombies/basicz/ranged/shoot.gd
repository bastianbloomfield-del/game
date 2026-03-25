extends Node2D

@onready var shoot_timer: Timer = $"shoot timer"
@onready var shootpos: Marker2D = $shootpos
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player")

const ENBULLET = preload("res://Entities/Enemys/zombies/basicz/ranged/enbullet.tscn")
@onready var self_shoot = $"."


func _physics_process(delta: float) -> void:
	var self_enemy_pos = self_shoot.global_position
	var player_pos = player.global_position
	var distance = self_enemy_pos.distance_to(player_pos)
	
	if distance < 100:
		_on_ranged_shoot_data(5, 0.5)
	
	
	

func _on_ranged_shoot_data(damage: int, shoot_speed: float) -> void:
	
	if not shoot_timer.is_stopped():
		return
	
	var new_bullet = ENBULLET.instantiate()
	var shoot_pos = $shootpos
	
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.global_rotation = shoot_pos.global_rotation
	
	# send damage to bullet
	new_bullet._on_data(damage)
	# IMPORTANT: add to scene root, not shootpos
	
	shoot_pos.add_child(new_bullet)
	shoot_timer.start(shoot_speed)
