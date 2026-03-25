extends Control
class_name sellmod

@export var card_frame: TextureRect 
var hovering: bool

@onready var price_tag: Label = $card/price


#modular mod 
@export var inventory_mod_scope: inventory_scope_mod  #has to be an item or inventory mod
@export var inventory_mod_barrel: inventory_barrel_mod
@export var inventory_mod_ammo: inventory_ammo_mod

var scope_mod: bool = false
var barrel_mod: bool = false
var ammo_mod: bool = false

@export var price = 0
var string_price: String
var int_price: int


# ok i need to see how i should do mods when the are brught and being loaded and - doing now - loaded
# also make it so they are added to the inventory
# whitch also needs designing along with that i should get more ui going


func _ready() -> void:
	
	string_price = str(price)
	int_price = price
	
	if inventory_mod_scope is inventory_scope_mod:
		for i in range(1):
			buy_scope_mod(inventory_mod_scope, 0)
		
	
	if inventory_mod_barrel is inventory_barrel_mod:
		for i in range(1):
			buy_barrel_mod(inventory_mod_barrel, 0)
			
	
	if inventory_mod_ammo is inventory_ammo_mod:
		for i in range(1):
			buy_ammo_mod(inventory_mod_ammo, 0)
		
	
	set_mod()

func _process(delta: float) -> void:
	
	if is_mouse_on_card():
		hovering = true
		card_frame.scale = Vector2(1.2, 1.2)
		
	else:
		hovering = false
		card_frame.scale = Vector2(1, 1)

func is_mouse_on_card() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var sprite_rect = Rect2(card_frame.global_position, card_frame.texture.get_size())
	return sprite_rect.has_point(mouse_pos)
	

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering and Global.main_ui == false:
			
			if price > Global.coins:
				return
			
			Global.coins -= int_price
			 
			
			if scope_mod == true:
				buy_scope_mod(inventory_mod_scope, 1)
			
			if barrel_mod == true:
				buy_barrel_mod(inventory_mod_barrel, 1)
			
			if ammo_mod == true:
				buy_ammo_mod(inventory_mod_ammo, 1)
			
			self.queue_free()
			
	

func set_mod():
	price_tag.text = string_price

func buy_scope_mod(mod: inventory_scope_mod, stage):
	if inventory_mod_scope == null:
		return
	
	scope_mod = true
	
	if stage == 0:
		pass # who knows
	
	if stage == 1:
		Global.add_mod = mod
		return
	

func buy_barrel_mod(mod: inventory_barrel_mod, stage):
	if inventory_mod_barrel == null:
		return
	
	barrel_mod = true
	
	if stage == 0:
		pass
	
	if stage == 1:
		Global.add_mod = mod
		return
	

func buy_ammo_mod(mod: inventory_ammo_mod, stage):
	if inventory_mod_ammo == null:
		return
	
	ammo_mod = true
	
	if stage == 0:
		pass
	
	if stage == 1:
		Global.add_mod = mod
		return
	
