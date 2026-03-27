extends Node2D

@export var ENEMY_1: PackedScene

@onready var shop: Node2D = $shop
@onready var cards: Node2D = $cards

var wave_on = false
# 1
var wave_card = 0 # 5
#var wave_boss = 0 # 10

var wave_start
var current_wave: int 

var enemy_array = []

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended


func _ready() -> void:
	shop.visible = false
	#cards.visible = false
	current_wave = 0
	wave_card = 5
	Global.current_wave = current_wave
	Global.roll_shop = false
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	
	position_to_next_wave()
	

func position_to_next_wave():
	if current_nodes == starting_nodes:
		if current_wave != 0:
			Global.moving_to_next_wave = true
		wave_start = false
		#animation
		
		
		
		wave_card += 1
		Global.card_wave = wave_card
		current_wave += 1
		Global.current_wave = current_wave
		prepare_spawn("enemy_1", 4.0, 4.0)



#                  zombies / amount a wave / all pos of spawns
func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time: float = 4.0
	var mob_spawns_rounds = mob_amount/mob_spawns
	spawn_type(type, mob_spawns_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_timer): # change this
	if type == "enemy_1":
		var north = $North
		var east = $East
		var south = $South
		var west = $West
		if mob_spawn_rounds >=1:
			for i in mob_spawn_rounds:
				var enemy_1 = ENEMY_1.instantiate()
				enemy_1.global_position = north.global_position
				var enemy_2 = ENEMY_1.instantiate()
				enemy_2.global_position = east.global_position
				var enemy_3 = ENEMY_1.instantiate()
				enemy_3.global_position = south.global_position
				var enemy_4 = ENEMY_1.instantiate()
				enemy_4.global_position = west.global_position
				add_child(enemy_1)
				add_child(enemy_2)
				add_child(enemy_3)
				add_child(enemy_4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_timer).timeout
			wave_spawn_ended = true
			
	

func _process(delta: float) -> void:
	if wave_on == false:
		#shop
		shop.visible = true
		Global.roll_shop = true
		#card
		cards.visible = false
		Global.roll_cards = true
		
		return
	
	#start wave ui
	
	#loop the enemy amount for each typr
	
	shop.visible = false
	#cards.visible = false
	
	current_nodes = get_child_count()
	
	if wave_spawn_ended:
		
		position_to_next_wave()
	
	


func _on_dayendtimeout_timeout() -> void: #starts wave
	wave_on = true
	$nightendtimeout.start()
	Global.wave_on = wave_on
	Global.roll_shop = false

func _on_nightendtimeout_timeout() -> void:
	wave_on = false
	$dayendtimeout.start()
	Global.wave_on = wave_on
	Global.roll_shop = true
