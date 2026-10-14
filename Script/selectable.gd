class_name Selectable
extends Node


signal selected
signal deselected


var is_selected := false
#var owner_object: Node


func _ready() -> void:
	var owner_object = get_parent()
	owner_object.add_to_group("selectable_owner")


func select() -> void:
	is_selected = true
	selected.emit()


func deselect() -> void:
	is_selected = false
	deselected.emit()
