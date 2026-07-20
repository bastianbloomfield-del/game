extends GridContainer

@onready var UI: GridContainer = $"."

func _ready() -> void:
	UI.visible = false


func _process(delta: float) -> void:
	UI.visible = Global.inventory_ui
