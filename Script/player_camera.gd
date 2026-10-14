extends Camera2D
#camera must be "top level"

@onready var my_player = $".."
@onready var tracked_object = my_player
var follow_speed = 450
var camera_locked := false
var edge_margin := 60

func _ready() -> void:
	global_position = tracked_object.global_position
	position_smoothing_enabled = camera_locked

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("focus_camera"):
		camera_locked = !camera_locked
		position_smoothing_enabled = camera_locked
		global_position = tracked_object.global_position
	
	if !camera_locked:
		var mouse_position := get_viewport().get_mouse_position()
		var viewport_size := get_viewport_rect().size
		
		if mouse_position.x < edge_margin:
			position.x -= follow_speed * delta
		elif mouse_position.x > viewport_size.x - edge_margin:
			position.x += follow_speed * delta
		if mouse_position.y < edge_margin:
			position.y -= follow_speed * delta
		elif mouse_position.y > viewport_size.y - edge_margin:
			position.y += follow_speed * delta
	else:
		global_position = tracked_object.global_position
