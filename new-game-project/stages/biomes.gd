extends Resource
class_name Biome

@export var name: String = "Biome"
@export var tile: Vector2i = Vector2i.ZERO

@export var temp_range: Vector2 = Vector2(0, 1)
@export var moist_range: Vector2 = Vector2(0, 1)
@export var altitude_range: Vector2 = Vector2(0, 1)

@export var noise: FastNoiseLite
