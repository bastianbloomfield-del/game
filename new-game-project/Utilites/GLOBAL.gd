extends Node

var coins: int = 100
var main_ui: bool = true
var roll_shop: bool
var roll_cards: bool

var current_wave: int
#sub waves
var card_wave: int
#moving wave
var wave_on: bool
var moving_to_next_wave: bool

var player_inventory: Array

var add_mod: Item 

var inventory_ui: bool
