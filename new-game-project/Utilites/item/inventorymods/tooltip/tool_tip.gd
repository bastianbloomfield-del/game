extends PanelContainer
class_name tooltip

@onready var type: Label = $main/type
@onready var stats: VBoxContainer = $main/stats


func set_item(item: Item):
	if item == null:
		return

	
	_clear_stats()
	
	type.text = item.type
	
	var stat = item.mod.name
	var l = Label.new()
	l.text = stat
	stats.add_child(l)
 

func _clear_stats():
	for i in stats.get_children():
		i.queue_free()
