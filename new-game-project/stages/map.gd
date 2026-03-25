extends TileMapLayer

@export var temperature = FastNoiseLite.new()
@export var altitude = FastNoiseLite.new()

var trees = FastNoiseLite.new()

var render_distance = 11
var chunk_size = 4
var current_chunk = Vector2()
var previous_chunk = Vector2()

var active_chunks = {}

@onready var Player = get_tree().current_scene.get_node("player")
@onready var map: TileMapLayer = $"."
@onready var enviroment: TileMapLayer = $enviroment

var source_id = 2
var plain = Vector2i(1,0)
var sand = Vector2i(2,0)
var forest = Vector2i(0,0)
var savanna = Vector2i(3,0)
var snow = Vector2i(1,1)
var mountains = Vector2i(0,1)
var water = Vector2i(0,3)

func _ready():
	
	var player_position = local_to_map(Player.global_position)
	current_chunk = _get_player_chunk(player_position)

	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.001
	
	trees.seed = randi()

func _process(delta: float) -> void:
	var player_pos = local_to_map(Player.global_position)
	current_chunk = _get_player_chunk(player_pos)
	
	if previous_chunk != current_chunk:
		remove_old_chunks()  # First, remove outdated chunks
		gen_chunk()  # Then generate new ones

	previous_chunk = current_chunk

func between(noise, start, end):
	if start <= noise and noise < end:
		return true

func gen_chunk():
	var render_bounds = (render_distance * 2) + 1
	
	for i in range(render_bounds):
		for a in range(render_bounds):
			var chunk_pos = Vector2i(current_chunk.x + i - render_distance, current_chunk.y + a - render_distance)
			active_chunks[chunk_pos] = true 

			for x in range((chunk_size)+2):
				for y in range((chunk_size)-3):
					var _x: int = round((x+1)+(i+1) - (round(render_bounds/2)) + (chunk_size * current_chunk.x))
					var _y: int = round((y+1)+(a+1) - (round(render_bounds/2)) + (chunk_size * current_chunk.y))
					
					var temp = round(abs(temperature.get_noise_2d(_x, _y) * 20))
					var alt = round(abs(altitude.get_noise_2d(_x, _y) * 70))
					
					var tree = round(abs(altitude.get_noise_2d(_x, _y) * 70))

					temp = min(temp, 12)
					alt = min(alt, 12)
					
					tree = min(tree, 12)
					
					if alt < 4:
						map.set_cell(Vector2i(_x, _y), source_id, water)
					elif between(alt, 4, 6):
						map.set_cell(Vector2i(_x, _y), source_id, sand)
					elif between(temp, 0, 1):
						map.set_cell(Vector2i(_x, _y), source_id, mountains)
					elif between(temp, 1, 2):
						map.set_cell(Vector2i(_x, _y), source_id, snow)
					elif between(temp, 2, 5):
						map.set_cell(Vector2i(_x, _y), source_id, plain)
					elif between(temp, 5, 8):
						map.set_cell(Vector2i(_x, _y), source_id, forest)
						
					elif between(temp, 8, 9):
						map.set_cell(Vector2i(_x, _y), source_id, savanna)
					elif between(temp, 9, 13):
						map.set_cell(Vector2i(_x, _y), source_id, sand)

func remove_old_chunks():
	var chunks_to_delete = active_chunks.keys()  # Get all previous chunks
	active_chunks.clear()  # Clear tracking

	for chunk in chunks_to_delete:
		_delete_chunk(chunk)  # Fully remove each chunk

func _delete_chunk(chunk_pos):
	for x in range(chunk_size):
		for y in range(chunk_size):
			var _x = (chunk_size * chunk_pos.x) + x
			var _y = (chunk_size * chunk_pos.y) + y
			
			map.erase_cell(Vector2i(_x, _y))
			#map.set_cell(Vector2i(_x, _y), source_id, Vector2i(-1, -1))  # Correct tile deletion

func _get_player_chunk(pos):
	var chunk_pos = Vector2()
	chunk_pos.y = int(pos.y / chunk_size)
	chunk_pos.x = int(pos.x / chunk_size)
	if pos.x < 0:
		chunk_pos.x -= 1
	if pos.y < 0:
		chunk_pos.y -= 1
	return chunk_pos
