class_name Trail
extends Line2D

@onready var parent = get_parent()

#func _process(_delta: float) -> void:
	#points.set(0, parent.global_position)
	#points.set(1, parent.global_position - parent.direction * 0.2)
