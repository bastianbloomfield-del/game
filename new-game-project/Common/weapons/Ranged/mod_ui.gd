extends Control
class_name mod_ui

@onready var control: mod_ui = $"."
@onready var ui: CanvasLayer = $UI

var scope_next = 0
var barrel_next = 0
var ammo_next = 0

@onready var scope_mod_displays: Control = $"UI/mod inv/scope/scope mod displays"
@onready var barrel_mod_displays: Control = $"UI/mod inv/barrel/barrel mod displays"
@onready var ammo_mod_displays: Control = $"UI/mod inv/ammo/ammo mod displays"

@onready var scope_slots: HBoxContainer = $"UI/mod inv/scope/scope mod displays/scope_slots"
@onready var barrel_slots: HBoxContainer = $"UI/mod inv/barrel/barrel mod displays/barrel_slots"
@onready var ammo_slots: HBoxContainer = $"UI/mod inv/ammo/ammo mod displays/ammo_slots"

@export var scope_inv: scope_mod_inv
@export var barrel_inv: barrel_mod_inv
@export var ammo_inv: ammo_mod_inv

@onready var player_inventory: GridContainer = $UI/player_inventory

var original


func _ready() -> void:
	original = Global.add_mod
	scope_mod_displays.visible = false
	barrel_mod_displays.visible = false
	ammo_mod_displays.visible = false


func _process(delta: float) -> void:
	var changed: bool = has_change()
	
	if Global.inventory_ui == true:
		update_mod_invs()
	
	if changed:
		add_mod_to_inventory(Global.add_mod)

	ui.visible = Global.inventory_ui


func _on_scope_pressed() -> void:
	scope_next = 1 - scope_next
	scope_mod_displays.visible = scope_next == 1


func _on_barrel_pressed() -> void:
	barrel_next = 1 - barrel_next
	barrel_mod_displays.visible = barrel_next == 1


func _on_ammo_pressed() -> void:
	ammo_next = 1 - ammo_next
	ammo_mod_displays.visible = ammo_next == 1


func add_mod_to_inventory(item: Item) -> void:
	if item == null:
		return
	
	
	for slot in player_inventory.get_children():
		if slot.item == null:
			slot.item = item
			Global.add_mod = null   # prevents repeated adding
			return

	print("Inventory full")


func has_change() -> bool:
	if original != Global.add_mod:
		original = Global.add_mod
		return true
	return false

func update_mod_invs():
	
	for i in range(scope_slots.get_child_count()):
		var scope_slot = scope_slots.get_child(i)
		
		if scope_slot.item == null:
			return
		
		else:
			if scope_slot.item.mod is scope_comp:
				var mod = scope_slot.item.mod
				append_scope_mods_to_comp(mod)
	
	for i in range(barrel_slots.get_child_count()):
		var barrel_slot = barrel_slots.get_child(i)
		
		if barrel_slot.item == null:
			return
		
		else:
			if barrel_slot.item.mod is barrel_comp:
				var mod = barrel_slot.item.mod
				append_barrel_mods_to_inventory(mod)
	
	for i in range(ammo_slots.get_child_count()):
		var ammo_slot = ammo_slots.get_child(i)
		
		if ammo_slot.item == null:
			return
		
		else:
			if ammo_slot.item.mod is ammo_comp:
				var mod = ammo_slot.item.mod
				append_ammo_mods_to_inventory(mod)



func append_scope_mods_to_comp(comp: scope_comp):
	scope_inv.scope.append(comp)

func append_barrel_mods_to_inventory(comp: barrel_comp):
	barrel_inv.barrel.append(comp)

func append_ammo_mods_to_inventory(comp: ammo_comp):
	ammo_inv.ammo.append(comp)
