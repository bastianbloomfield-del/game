extends Node2D

@export var name_m = "" 
@export var damage = 0

func s():
	look_at(get_global_mouse_position())
	
func _physics_process(delta):
	s()
