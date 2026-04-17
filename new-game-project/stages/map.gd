extends TileMapLayer

@export var contenentilness = FastNoiseLite.new() # controls the size of the land

@export var temperature = FastNoiseLite.new() # biome
@export var altitude = FastNoiseLite.new() # biome water
@export var moisture = FastNoiseLite.new()

var trees = FastNoiseLite.new()

var chunk_size = 17
var render_distance: int = 5
 
var current_chunk = Vector2i()
var previous_chunk = Vector2i()

var active_chunks = {}

@onready var Player = get_tree().current_scene.get_node("player")
@onready var map: TileMapLayer = $"." 
@onready var enviroment: TileMapLayer = $enviroment

@export var biomes = []


var source_id = 2

var plain = Vector2i(2,1)

var sand = Vector2i(0,3)
var forest = Vector2i(1,1)
var savanna = Vector2i(0,2)
var snow = Vector2i(0,0)
var mountains = Vector2i(2,0)

var water = Vector2i(3,0 )

var plains_tile: Vector2i 
var sands_tile: Vector2i
var forest_tile: Vector2i
var savannas_tile: Vector2i
var snowy_tile: Vector2i


func _ready() -> void: # in ready have a get biomes func to get all the
	# biome data in to vars like snow tile and snow noise
	
	
	debug_scan()
	
	temperature.seed = randi()
	altitude.seed = randi()
	moisture.seed = randi()
	contenentilness.seed = randi()
	
	contenentilness.frequency = 0.0034
	temperature.frequency = 0.001
	moisture.frequency = 0.01
	
	altitude.frequency = 0.001
	
	trees.seed = randi()
	
	_update_player_chunk()
	_load_visible_chunks()


func _process(delta: float) -> void:
	_update_player_chunk()
	
	if current_chunk != previous_chunk:
		_load_visible_chunks()
		
	
	previous_chunk = current_chunk

func get_biomes():
	pass




func _update_player_chunk() -> void:
	var pos = local_to_map(Player.global_position)
	current_chunk = Vector2i(
		floor(pos.x / chunk_size),
		floor(pos.y / chunk_size)
	)

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
			
			var cont = round(abs(contenentilness.get_noise_2d(_x, _y) * 20.0)) # -10 - -12
			var temp = roundi(abs(temperature.get_noise_2d(_x, _y) * 20.0)) # -17 - 16
			var alt = roundi(abs(altitude.get_noise_2d(_x, _y) * 70.0)) # -60 - 57
			var moist = round(abs(moisture.get_noise_2d(_x, _y) * 20.0)) # -17 - 16
			#var tree = roundi(abs(trees.get_noise_2d(_x, _y) * 70.0))
			
			temp = min(temp, 12)
			alt = min(alt, 12)
			
			if cont < -10:
				map.set_cell(pos, source_id, water)
			
			elif alt < 6:
				map.set_cell(pos, source_id, water)
			
			elif alt < 7:
				map.set_cell(pos, source_id, sand)
			
			elif between(alt, 10, 20) and between(temp, 3, 7) and between(moist, -5, 2):
				map.set_cell(pos, source_id, mountains)
			
			elif between(alt, 9, 30) and between(temp, 5, 14) and between(moist, -3, 4):
				map.set_cell(pos, source_id, forest)
			
			elif between(alt, 9, 25) and between(temp, -7, 5) and between(moist, -6, 3):
				map.set_cell(pos, source_id, snow)
			
			elif between(alt, 9, 30) and between(temp, -17, 16) and between(moist, 10, 30):
				map.set_cell(pos, source_id, sand)
			
			else:
				map.set_cell(pos, source_id, plain)

func _delete_chunk(chunk_pos: Vector2i) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			var _x = chunk_pos.x * chunk_size + x
			var _y = chunk_pos.y * chunk_size + y
			map.erase_cell(Vector2i(_x, _y))

func between(value: float, start: float, end: float) -> bool:
	return start <= value and value < end

func debug_scan():
	var min_val := 999999.0
	var max_val := -999999.0

	for x in range(-600, 600):
		for y in range(-600, 600):
			var v = (moisture.get_noise_2d(x, y) * 20.0)
			min_val = min(min_val, v)
			max_val = max(max_val, v)

	print("Temperature noise min:", min_val) 
	print("Temperature noise max:", max_val)
