extends Node2D

@export var foliage_noise = FastNoiseLite.new()
@export var temperature = FastNoiseLite.new()
@export var altitude = FastNoiseLite.new()
@export var moisture = FastNoiseLite.new()

var trees = FastNoiseLite.new()

var chunk_size = 17
var render_distance: int = 5

var current_chunk = Vector2i()
var previous_chunk = Vector2i()

var active_chunks = {}

@onready var Player = $"../y-sort/player"
@export var biomes = []

@onready var foliage: TileMapLayer = $"../y-sort/foliage"
@onready var biome: TileMapLayer = $biomes
@onready var ocean: TileMapLayer = $ocean

var source_id = 1

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

var tree_1 = Vector2i(0,0)
var tree_2 = Vector2i(2,0)

func _ready() -> void:
	temperature.seed = randi()
	altitude.seed = randi()
	moisture.seed = randi()
	foliage_noise.seed = randi()
	
	temperature.frequency = 0.0043
	moisture.frequency = 0.0043
	altitude.frequency = 0.001
	trees.seed = randi()

	_update_player_chunk()
	_load_visible_chunks()
	debug()
	
	Player.global_position = find_valid_spawn(Player.global_position)

func _process(delta: float) -> void:
	_update_player_chunk()

	if current_chunk != previous_chunk:
		_load_visible_chunks()

	previous_chunk = current_chunk


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
			
			var alt = abs(roundi(altitude.get_noise_2d(_x, _y) * 70.0)) # 0 - 43
			var foil = abs(roundi(foliage_noise.get_noise_2d(_x, _y) * -10.0)) # 1-9
			var temp = abs(roundi(temperature.get_noise_2d(_x, _y) * -20.0)) #3 - 18
			var moist = abs(roundi(moisture.get_noise_2d(_x, _y) * -20.0)) #3 - 18
			
			if alt < 8:
				ocean.set_cell(pos, source_id, water)
				continue
			
			if alt < 9:
				biome.set_cell(pos, source_id, beach)
				continue
			
			if alt > 41:
				biome.set_cell(pos, source_id, mountains)
				continue
			
			if between(temp, 2, 8):
				
				if between(moist, 2, 5):
					biome.set_cell(pos, source_id, ice_spikes)
					continue
				
				if between(moist, 5, 7):
					biome.set_cell(pos, source_id, ice_sheets)
					continue
				
				if between(moist, 7, 11):
					biome.set_cell(pos, source_id, tundra)
					continue
				
				biome.set_cell(pos, source_id, snow)
				continue

			if between(temp, 8, 13):
				if between(moist, 2, 5):
					biome.set_cell(pos, source_id, hills)
					continue
				
				if between(moist, 5, 7):
					biome.set_cell(pos, source_id, marshs)
					continue
				
				if between(moist, 7, 11):
					biome.set_cell(pos, source_id, forests)
					if between(foil, 0 ,6):
						foliage.set_cell(pos, 0, tree_2)
					
					continue
				if between(moist, 2, 19):
					biome.set_cell(pos, source_id, plains)
					
					if between(foil, 1, 3):
						foliage.set_cell(pos, 0, tree_1)
						
					
				
				continue

			if between(temp, 12, 19):
				
				if between(moist, 2, 5):
					biome.set_cell(pos, source_id, mesa)
					continue
				
				if between(moist, 7, 11):
					biome.set_cell(pos, source_id, savanna)
					continue
				
				biome.set_cell(pos, source_id, desert)
				continue
			
			biome.set_cell(pos, source_id, water)

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

func debug():
	var min_val := 999999.0
	var max_val := -999999.0

	for x in range(-600, 600):
		for y in range(-600, 600):
			var v = abs((foliage_noise.get_noise_2d(x, y) * -10.0))
			min_val = min(min_val, v)
			max_val = max(max_val, v)

	print("Temperature noise min:", min_val) 
	print("Temperature noise max:", max_val)

func find_valid_spawn(start_pos: Vector2) -> Vector2:
	var map_pos = biome.local_to_map(start_pos)
	
	for radius in range(1, 100):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				
				var check_pos = map_pos + Vector2i(x, y)
				var biome_tile = biome.get_cell_source_id(check_pos)
				
				if biome_tile != -1:
					return biome.map_to_local(check_pos)
					
	return start_pos
