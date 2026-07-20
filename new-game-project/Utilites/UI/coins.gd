extends Label

@onready var coins: Label = $"."
var temp: String

func _process(delta: float) -> void:
	
	if temp == str(Global.coins):
		return
		
	temp = str(Global.coins)
	coins.text = str(Global.coins)
