class_name DamageEmitier
extends Area2D


var exported_damage = 0 
var exported_effect


func _init() -> void:
	collision_layer = 2
	collision_mask = 0

# for bullet - to enemy
func _on_bullet_data(damage: Variant, effect: Variant) -> void:
	exported_damage = damage
	exported_effect = effect

func _on_stab_data(damage: Variant) -> void:
	exported_damage = damage
	

func _on_enbullet_data(damage: Variant) -> void:
	exported_damage = damage
