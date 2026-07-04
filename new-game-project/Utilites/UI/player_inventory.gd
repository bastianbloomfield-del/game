extends GridContainer

@onready var UI: GridContainer = $"."

func _ready() -> void:
	pass
	#UI.visible = false


func _process(delta: float) -> void:
	pass
	#UI.visible = Global.inventory_ui
