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

var hovering: bool

func _ready() -> void:
	load_cards()

func _process(delta: float) -> void:
	pass


func load_cards(): #loads all the data
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

func take_card(): # takes the card
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

func is_mouse_on_option() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var sprite_rect = Rect2(option.global_position, option.get_size())
	return sprite_rect.has_point(mouse_pos)

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering:
			take_card
