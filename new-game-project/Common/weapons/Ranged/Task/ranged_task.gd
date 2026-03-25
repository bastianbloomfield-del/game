extends Node2D
class_name gun

#const BULLET := preload("res://Common/weapons/Bullet/bullet.tscn")
const BULLET := preload("res://Common/weapons/Bullet/bullet.tscn")

#scope
@export var scope_inventory: scope_mod_inv
@onready var scope_inv: scope_mod_inv = preload("res://Common/weapons/modinvs/main_scope_inv.tres")
#barrel
@export var barrel_inventory: barrel_mod_inv
@onready var barrel_inv: barrel_mod_inv = preload("res://Common/weapons/modinvs/main_barrel_inv.tres")
#ammo
@export var ammo_inventory: ammo_mod_inv
@onready var ammo_inv: ammo_mod_inv = preload("res://Common/weapons/modinvs/main_ammo_inv.tres")

var level = 0
var xp = 0
var nextlev = 100
var levelmulti = 1.5
var dammulti = 1.15
#abilities
var effect = ""
#main stuff
@export var max_ammo = 0
@export var ammo = 0
@export var reload_time = 0.
@export var shoot_time = 0.
@export var damage = 0
#timers
@onready var _shoot_timer = $shoot_timer
@onready var _reload_timer = $reload_timer


#ui
@export var MOD_UI: mod_ui


func _ready() -> void:
	
	effect = "none"
	
	for i in range(scope_inv.scope.size()):
		get_ability_from_scope(scope_inv.scope[i])
	
	for i in range(barrel_inv.barrel.size()):
		get_damage_from_barrel(barrel_inv.barrel[i])
	
	for i in range(ammo_inv.ammo.size()):
		get_ammoincrease_and_reloadsoeed_from_ammo(ammo_inv.ammo[i])

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	
	# shooting and reloading
	
	if Global.inventory_ui == true:
		# run / call functions of mod ui
		
		for i in range(scope_inv.scope.size()):
			get_ability_from_scope(scope_inv.scope[i])
			
		for i in range(barrel_inv.barrel.size()):
			get_damage_from_barrel(barrel_inv.barrel[i])
			
		for i in range(ammo_inv.ammo.size()):
			get_ammoincrease_and_reloadsoeed_from_ammo(ammo_inv.ammo[i])
		
		
		return
	
	if _reload_timer and not _reload_timer.is_stopped():
		return
		
	if Input.is_action_pressed("ATTACK"):
		if ammo > 0:
			shoot()#make bullet
			
			
		if ammo <= 0:#my reload
			_reload_timer.start(reload_time)
			ammo += max_ammo

func shoot():
	if _shoot_timer and not _shoot_timer.is_stopped():
		return
	
	# shoot bullet
	
	var new_bullet = BULLET.instantiate()
	var shoot_pos = $shootpos   # cache the node once
	
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.global_rotation = shoot_pos.global_rotation
	
	new_bullet._on_data(damage, effect)
	
	
	%shootpos.add_child(new_bullet)
	_shoot_timer.start(shoot_time)
	
	ammo -= 1
	xp = xp + 1
	
	if xp == nextlev:
		level = level + 1
		xp = 0
		nextlev = nextlev * levelmulti
		
		damage = damage * dammulti

func get_ability_from_scope(mod: scope_comp): # works - done
	if mod == null:
		return
	
	effect = mod.abilty
	

func get_damage_from_barrel(mod: barrel_comp):
	if mod == null:
		return
		
	var total_dama = 0
	total_dama =+ mod.damage_increase
	damage =+ total_dama

func get_ammoincrease_and_reloadsoeed_from_ammo(mod: ammo_comp):
	if mod == null:
		return
	
	var ammo_increase = mod.ammo_increae_max
	max_ammo =+ ammo_increase
	var reload_speed_lower = mod.reload_time
	_reload_timer =- reload_speed_lower
	
