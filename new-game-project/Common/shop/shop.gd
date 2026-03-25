extends Node2D

@onready var _1: Marker2D = $"display/1"
@onready var _2: Marker2D = $"display/2"
@onready var _3: Marker2D = $"display/3"
@onready var _4: Marker2D = $"display/4"
@onready var _5: Marker2D = $"display/5"


@onready var control: Control = $CanvasLayer/Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer


@onready var H_box: HBoxContainer = $CanvasLayer/Control/HBoxContainer


@onready var sellmods:Array = ["res://Common/shop/shopitem.tscn"]             


var limit = 1


func roll_shop(): # for mods for now
	
	for i in range(5):
		var random = randi_range(0,0)
		
		var test = load(sellmods[random])
		
		var new_shop_item = test.instantiate()
		H_box.add_child(new_shop_item)
	#make a random weapon appear to equip for a price so nned to add a new game system



func _ready() -> void:
	control.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	control.visible = true
	Global.main_ui = false
	
	
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	control.visible = false
	Global.main_ui = true
	
	limit = 1
	
	for child in H_box.get_children():
		child.queue_free()



func _process(delta: float) -> void:
	if Global.roll_shop == true:
		if limit == 0:
			return
		roll_shop()
		limit = 0
	else:
		return
	
