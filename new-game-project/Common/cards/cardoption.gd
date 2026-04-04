extends Control

@onready var option: Panel = $"option 1"

@onready var good: Panel = $"option 1/good"
@onready var name_good: Label = $"option 1/good/name"
@onready var info_good: Label = $"option 1/good/info"
@onready var texture_good: TextureRect = $"option 1/good/texture"

@onready var bad: Panel = $"option 1/bad"
@onready var name_bad: Label = $"option 1/bad/name"
@onready var info_bad: Label = $"option 1/bad/info"
@onready var texture_bad: TextureRect = $"option 1/bad/texture"

@export var GOOD_card: good_card
@export var BAD_card: bad_card

var hovering := false

func _ready():
	load_cards()

func set_cards(good, bad):
	GOOD_card = good
	BAD_card = bad
	load_cards()
#aaaaaaa
func load_cards():
	if GOOD_card == null:
		name_good.text = ""
		info_good.text = ""
		texture_good.texture = null
	else:
		name_good.text = GOOD_card.name
		info_good.text = GOOD_card.info
		texture_good.texture = GOOD_card.texture

	if BAD_card == null:
		name_bad.text = ""
		info_bad.text = ""
		texture_bad.texture = null
	else:
		name_bad.text = BAD_card.name
		info_bad.text = BAD_card.info
		texture_bad.texture = BAD_card.texture

func _process(delta):
	if is_mouse_on_option():
		hovering = true
		option.scale = Vector2(1.2, 1.2)
	else:
		hovering = false
		option.scale = Vector2(1.0, 1.0)

func is_mouse_on_option() -> bool:
	return option.get_global_rect().has_point(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering:
			take_card()

func take_card():# have another global script for all the variables and if they true do the fuction 
	#of them but need to see if there is a way to do theis with little lag could have a loop once if a card is selected
	
	CardsEffects.changed = true # when do we set it to false? were 
	
	print("Card taken: ", GOOD_card.effect, BAD_card.effect)
	var good_card_effect = GOOD_card.effect
	var bad_card_effect = BAD_card.effect
	
	if good_card_effect == "30 faster player":
		print("aaaaaaaaaaaaaaaa")
