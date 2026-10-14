extends Area2D

@export var weapon := preload("res://Resource/weapons/weapon_starter.tres")
@export var fire_rate := 20
@onready var fire_rate_timer: Timer = $Fire_Rate_Timer
var structure_owner = null

#func _on_fire_rate_timer_timeout() -> void:
	#var bullet_direction = global_position.direction_to(get_global_mouse_position())
	#weapon.fire(self, bullet_direction)
	#fire_rate_timer.start()
