class_name DamageRecivier
extends Area2D

signal hit(damage, effect)
var damage
var effect


func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: DamageEmitier) -> void:
	damage = hitbox.exported_damage
	effect = hitbox.exported_effect
	emit_signal("hit", damage, effect)
