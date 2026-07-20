extends ProgressBar

@onready var health_bar: ProgressBar = $"."
@onready var original: int = Global.player_health

func _ready() -> void:
	health_bar.value = Global.player_health

func _process(delta: float) -> void:
	if original != Global.player_health:
		health_bar.value = Global.player_health
