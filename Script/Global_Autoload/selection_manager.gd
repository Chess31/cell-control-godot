extends Node

var selected_objects: Array[Selectable] = []


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("world_select"):
		select_under_mouse()


func select_under_mouse() -> void:
	#mouse position in world space to check for hits = inverse of viewport transform * viewport mouse position.
	var mouse_position := get_viewport().get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()
	
	#define the physics world query point
	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	
	#hits becomes an array of all objects under the cursor
	var space_state := get_viewport().get_world_2d().direct_space_state
	var hits := space_state.intersect_point(query)

	#filter hits and only call select_objects on things with a selectable component
	for hit in hits:
		var object = hit.collider
		
		#selectable owener = group of root nodes with selectable components.
		#Allows CollisionShape and Selectable nodes to be anywhere within the object's node tree
		if object.is_in_group("selectable_owner"):
			var selectable = object.get_node("Selectable")
			
			select_object(selectable)
			return
	#if return is not called (no selectable objects), then clear selection
	clear_selection()


func select_object(object: Selectable) -> void:
	clear_selection()

	selected_objects.append(object)
	object.select()


func clear_selection() -> void:
	for object in selected_objects:
		object.deselect()

	selected_objects.clear()
