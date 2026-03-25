extends CharacterBody2D



signal stab_data(damage)

@onready var self_enemy: CharacterBody2D = $"."
@onready var player_position: CharacterBody2D = get_tree().current_scene.get_node("player")

#atrrabutes


@export var min_health: int = 0
@export var max_health: int = 0
var health: int 

@export var min_speed: float = 0
@export var max_speed: float = 0
var speed: float

@export var min_damage: int = 0
@export var max_damage: int = 0
var damage: int



var hit_effect
var hit_damage

@onready var raycast_map: Node = $context_map
var raycast: Array

# arrays
var vector_map: Array[Vector2] = [Vector2(0,-1), Vector2(1,-1), Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1)]
var danger_array: Array[float] = [0,0,0,0,0,0,0,0]
var interest_array: Array[float] = []
var context_map: Array[float] = [0,0,0,0,0,0,0,0]

var player_normilized_dir: Vector2
var chosen_index: int = -1   # store which direction was chosen

@onready var nav_ai: NavigationAgent2D = $NavigationAgent2D

#timer

@onready var hit_wait: Timer = $hit_wait

#attck 

@onready var stab: Node2D = $stab







func _ready() -> void:
	#which attack
	
	
	
	
	#attrabutes
	health = randi_range(min_health, max_health)
	speed = randf_range(min_speed, max_speed)
	damage = randi_range(min_damage, max_damage)
	
	raycast = raycast_map.get_children()
	for i in range(raycast.size()):
		var rc := raycast[i] as RayCast2D
		rc.target_position = vector_map[i].normalized() * 15
		rc.enabled = true

func attack():
	emit_signal("stab_data", damage)


func take_damage(damage_taken):
	hit_wait.start()
	health -= damage_taken
	
	if health <= 0:
		Global.coins = Global.coins + randi_range(3, 7)
		queue_free()

func navigate_path() -> void:
	nav_ai.target_position = player_position.global_position
	player_normilized_dir = (nav_ai.get_next_path_position() - global_position).normalized()

func convert_path_to_interest() -> void:
	interest_array.clear()
	for v in vector_map:
		var dot_product = v.normalized().dot(player_normilized_dir)
		interest_array.push_back(dot_product)

func convert_path_to_danger() -> void:
	danger_array = [0,0,0,0,0,0,0,0]
	for i in range(raycast.size()):
		var rc := raycast[i] as RayCast2D
		if rc.is_colliding():
			danger_array[i] = 5
			if i > 0:
				danger_array[i-1] = 2
			else:
				danger_array[danger_array.size() -1] = 2
			if i < danger_array.size() -1:
				danger_array[i+1] = 2
			else:
				danger_array[0] = 2
			
			
#			danger_array[i] = 1.0
#			# soften neighbors
#			danger_array[(i - 1 + danger_array.size()) % danger_array.size()] = 0.8
#			danger_array[(i + 1) % danger_array.size()] = 0.8

func calculate_concept_map() -> void:
	for i in range(interest_array.size()):
		context_map[i] = interest_array[i] - danger_array[i] * 2.0   # stronger avoidance

func convert_context_map_to_direction(_delta: float) -> void:
	var num := -INF
	chosen_index = -1
	for i in range(context_map.size()):
		if context_map[i] > num:
			num = context_map[i]
			chosen_index = i
	if chosen_index == -1:
		return
	var desired := vector_map[chosen_index].normalized()
	#var acc := (desired * speed - velocity)
	
	# Smooth steering instead of hard normalize
	velocity = velocity.lerp(desired * speed, 0.1)
	move_and_slide()

func _physics_process(delta: float) -> void:
	var self_enemy_pos = self_enemy.global_position
	var player_pos = player_position.global_position
	var distance = self_enemy_pos.distance_to(player_pos)
	
	if distance < 25:
		
		attack()
	
	
	navigate_path()
	convert_path_to_interest()
	convert_path_to_danger()
	calculate_concept_map()
	convert_context_map_to_direction(delta)
	
	queue_redraw()  # refresh debug lines

func _draw() -> void:
	# Draw chosen velocity vector in red
	draw_line(Vector2.ZERO, velocity, Color.RED, 2)

	# Draw all possible directions
	for i in range(vector_map.size()):
		var color = Color.GRAY
		if i == chosen_index:
			color = Color.GREEN   # highlight chosen direction
		draw_line(Vector2.ZERO, vector_map[i].normalized() * 20, color, 2)

func _on_damage_recivier_hit(damage: int, effect: String) -> void:
	if not hit_wait.is_stopped():
		return
	
	
	hit_damage = damage
	hit_effect =  effect
	take_damage(hit_damage)
