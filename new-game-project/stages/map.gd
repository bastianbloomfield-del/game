extends Node2D

@export var contenentilness = FastNoiseLite.new()
@export var temperature = FastNoiseLite.new()
@export var altitude = FastNoiseLite.new()
@export var moisture = FastNoiseLite.new()

var trees = FastNoiseLite.new()

var chunk_size = 17
var render_distance: int = 5

var current_chunk = Vector2i()
var previous_chunk = Vector2i()

var active_chunks = {}

@onready var Player = get_tree().current_scene.get_node("player")
@export var biomes = []

@onready var foliage: TileMapLayer = $foliage
@onready var biome: TileMapLayer = $biomes
@onready var ocean: TileMapLayer = $ocean

var source_id = 0

var water = Vector2i(1,0)

var beach = Vector2i(0,1)
var desert = Vector2i(2,1)
var savanna = Vector2i(3,1)
var mesa = Vector2i(4,1)

var marshs = Vector2i(0,2)
var plains = Vector2i(2,2)
var forests = Vector2i(3,2)
var hills = Vector2i(4,2)

var ice_sheets = Vector2i(0,3)
var snow = Vector2i(2,3)
var tundra = Vector2i(3,3)
var ice_spikes = Vector2i(4,3)

var mountains = Vector2i(2,4)

var grass = Vector2i(0,4)
var flowers = Vector2i(1,4)

func _ready() -> void:
	temperature.seed = randi()
	altitude.seed = randi()
	moisture.seed = randi()
	contenentilness.seed = randi()

	contenentilness.frequency = 0.0034
	temperature.frequency = 0.0043
	moisture.frequency = 0.0043
	altitude.frequency = 0.001

	trees.seed = randi()

	_update_player_chunk()
	_load_visible_chunks()

func _process(delta: float) -> void:
	_update_player_chunk()

	if current_chunk != previous_chunk:
		_load_visible_chunks()

	previous_chunk = current_chunk

func get_biome(temp: int, moist: int, alt: int) -> Vector2i:
	if alt < 6: # oceans
		return water
	
	if alt < 8: # beaches
		return beach
	
	if alt > 41: # mountains
		return mountains
	
	
	#cold
	if between(temp, 2, 8):
		
		if between(moist, 2, 5):
			return ice_spikes  # 15% have 3/ 
		
		if between(moist, 5, 7):
			return ice_sheets
		
		if between(moist, 7, 11):
			return tundra
			
		
		return snow
	
	#warm
	if between(temp, 8, 13):
		if between(moist, 2, 5):
			return hills  # 15% have 3/ 
		
		if between(moist, 5, 7):
			return marshs
		
		if between(moist, 7, 11):
			return forests # 25% have 4
		
		
		return plains # 50% leave 8 
	
	#hot
	if between(temp, 12, 18):
		
		if between(moist, 2, 5):
			return mesa  # 15% have 3/ 
		
		if between(moist, 7, 11):
			return savanna
		return desert
		
	return water

func _update_player_chunk() -> void:
	var pos = biome.local_to_map(Player.global_position)
	current_chunk = Vector2i(floor(pos.x / chunk_size),floor(pos.y / chunk_size))

func _load_visible_chunks() -> void:
	var needed_chunks: Array[Vector2i] = []
	
	for x in range(-render_distance, render_distance + 1):
		for y in range(-render_distance, render_distance + 1):
			var chunk = current_chunk + Vector2i(x, y)
			
			if chunk.distance_to(current_chunk) <= render_distance:
				needed_chunks.append(chunk)
				
				if not active_chunks.has(chunk):
					_generate_chunk(chunk)
					active_chunks[chunk] = true

	for chunk in active_chunks.keys():
		if chunk not in needed_chunks:
			_delete_chunk(chunk)
			active_chunks.erase(chunk)

func _generate_chunk(chunk_pos: Vector2i) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			
			var _x = chunk_pos.x * chunk_size + x
			var _y = chunk_pos.y * chunk_size + y
			var pos = Vector2i(_x, _y)
			
			var cont = abs(roundi(contenentilness.get_noise_2d(_x, _y) * 20.0))
			var temp = abs(roundi(temperature.get_noise_2d(_x, _y) * 20.0)) # 2 - 18
			var alt = abs(roundi(altitude.get_noise_2d(_x, _y) * 70.0)) # 0 - 13
			var moist = abs(roundi(moisture.get_noise_2d(_x, _y) * 20.0)) # 2 -18
			
			
			var biome_tile = get_biome(temp, moist, alt)
			biome.set_cell(pos, source_id, biome_tile)

func _delete_chunk(chunk_pos: Vector2i) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			var _x = chunk_pos.x * chunk_size + x
			var _y = chunk_pos.y * chunk_size + y
			foliage.erase_cell(Vector2i(_x, _y))
			biome.erase_cell(Vector2i(_x, _y))
			ocean.erase_cell(Vector2i(_x, _y))

func between(value: float, start: float, end: float) -> bool:
	return start <= value and value < end
