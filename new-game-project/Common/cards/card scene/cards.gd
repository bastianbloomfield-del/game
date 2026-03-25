extends Node2D

@onready var option_1: Control = $CanvasLayer/Control/HBoxContainer/option1
@onready var option_2: Control = $CanvasLayer/Control/HBoxContainer/option2


# array of good cards
# array of bad cards

var good_cards = []
var bad_cards = []


func roll_cards():
	for i in range(2):
		var random_good = randi_range(0,0)
		var random_bad = randi_range(0,0)
		
		var card_good = load(good_cards[random_good])
		var card_bad = load(bad_cards[random_bad])
		
		# add the cards to option 1 then option 2
	

func _process(delta: float) -> void:
	if Global.roll_cards == true:
		
		roll_cards()
	else:
		return
