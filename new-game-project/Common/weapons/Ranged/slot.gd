extends Panel

@export var item: Item = null:
	set(value):
		item = value
		if value == null:
			$icon.texture = null
		else:
			$icon.texture = value.icon

@export var slot_type: String = ""

@export var tooltip_scene: PackedScene
var Tooltip: tooltip

var hover_time: float = 0.0
var is_hovered: bool = false
var dragging: bool = false


func _process(delta: float) -> void:
	if not dragging and is_hovered and not is_instance_valid(Tooltip):
		hover_time += delta

		if hover_time >= 3.0:
			if tooltip_scene:
				Tooltip = tooltip_scene.instantiate()
				get_tree().current_scene.find_child("UI").add_child(Tooltip)
				Tooltip.set_item(item)
				Tooltip.global_position = get_global_mouse_position()

	_update_tooltip_pos()


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if "item" in data:
		if data.item == null:
			return false

		if data.item.type != slot_type and slot_type != "any":
			return false

		return is_instance_of(data.item, Item)

	return false


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp = item
	item = data.item
	data.item = temp


func _get_drag_data(at_position: Vector2) -> Variant:
	if item:
		dragging = true
		var preview_texture := TextureRect.new()
		preview_texture.texture = item.icon
		preview_texture.size = Vector2(8, 8)
		preview_texture.position = -Vector2(8, 8)

		var preview := Control.new()
		preview.add_child(preview_texture)

		set_drag_preview(preview)
		_update_tooltip_pos()
		return self
	else:
		dragging = false
		return null


func _update_tooltip_pos() -> void:
	if Tooltip and not dragging:
		Tooltip.global_position = get_global_mouse_position()




func _on_mouse_entered() -> void:
	if dragging:
		return

	is_hovered = true
	hover_time = 0.0


func _on_mouse_exited() -> void:
	is_hovered = false
	hover_time = 0.0

	if is_instance_valid(Tooltip):
		Tooltip.queue_free()
	Tooltip = null
