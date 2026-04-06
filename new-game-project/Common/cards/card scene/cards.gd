extends Node2D

@onready var option_1: Control = $CanvasLayer/Control/HBoxContainer/option1
@onready var option_2: Control = $CanvasLayer/Control/HBoxContainer/option2

var good_cards = ["res://tests/good_teat.tres"]

var bad_cards = ["res://tests/bad_test.tres"]

func roll_cards():
	# OPTION 1
	var good1 = load(good_cards[randi_range(0, good_cards.size() - 1)])
	var bad1 = load(bad_cards[randi_range(0, bad_cards.size() - 1)])
	option_1.set_cards(good1, bad1)

	# OPTION 2
	var good2 = load(good_cards[randi_range(0, good_cards.size() - 1)])
	var bad2 = load(bad_cards[randi_range(0, bad_cards.size() - 1)])
	option_2.set_cards(good2, bad2)

func _process(delta):
	if Global.roll_cards:
		roll_cards()
		Global.roll_cards = false
	
	
