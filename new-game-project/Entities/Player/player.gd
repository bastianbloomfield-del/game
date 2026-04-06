extends CharacterBody2D
class_name player

# fix palyer animation ect
@export var speed = 50
@export var accel = 5
@export var friction = 8

@onready var animated_player: AnimatedSprite2D = $Sprite2D/AnimatedSprite2D

#ui
@onready var ui: CanvasLayer = $ui

#healthbar
@onready var healthbar = $ui/Control/healthbar
@export var health = 100

#coins
@onready var coins_display: Label = $ui/Control/coins




@onready var hit_wait: Timer = $hit_wait

var hit_damage
var hit_effect

var current_effect: String

var hold = 0
var time = 1
var once = 0



func _physics_process(delta: float) -> void:
	if CardsEffects.changed == true:
		
		if once == 0:
			print("11111111")
			speed =+ CardsEffects.player_speed
			
			healthbar.max_value =+ CardsEffects.player_health
			health =+ CardsEffects.player_health
		
		once == 1
		
	
	
	
	if Input.is_action_pressed("openclose inventory") and hold == 0:
		Global.inventory_ui = true
		await get_tree().create_timer(time).timeout
		hold = 1
	if Input.is_action_pressed("openclose inventory") and hold == 1:
		Global.inventory_ui = false
		await get_tree().create_timer(time).timeout
		hold = 0
	
	if Global.main_ui == false:
		ui.visible = false
		
		coins_display.text = str(Global.coins)
		
	else: 
		ui.visible = true
	
	var input = Vector2(
		Input.get_action_strength("MOVEd") - Input.get_action_strength("MOVEa"),
		Input.get_action_strength("MOVEs") - Input.get_action_strength("MOVEw")
	).normalized()
	
	if input:
		animated_player.play("boy(walk)")
		
		if input.x < 0:
			animated_player.flip_h = true
		else:
			animated_player.flip_h = false
		
		animated_player.speed_scale = (velocity/speed).distance_to(Vector2.ZERO) + 0.5
	
	else:
		animated_player.play("boy(idle)")
		animated_player.speed_scale = 0.75
		
	
	var lerp_weight = delta * (accel if input else friction)
	velocity = lerp(velocity, input * speed, lerp_weight)
	
	move_and_slide()


func take_damage(damage):
	health -= damage
	healthbar.value = health
	
	if health <= 0:
		pass
	
	animated_player.play("boy(damage)")
	





func _on_damage_recivier_hit(damage: Variant, effect: Variant) -> void:
	effect = effect
	take_damage(damage)


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
