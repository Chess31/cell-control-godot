extends Area2D

signal hit_detected(target: Node2D, damage: int)

var direction = null
var speed = null
var damage = null
var bullet_owner = null
var bullet_team = null

func _physics_process(delta: float) -> void:
	var start_position: Vector2 = global_position
	var end_position: Vector2 = start_position + direction * speed * delta

	var query := PhysicsRayQueryParameters2D.create(
		start_position,
		end_position,
		collision_mask
	)

	query.collide_with_areas = true
	query.collide_with_bodies = true

	#exclude this bullet and its owner from collision query
	var excluded_rids: Array[RID] = [get_rid()]

	if is_instance_valid(bullet_owner):
		excluded_rids.append(bullet_owner.get_rid())

	query.exclude = excluded_rids

	var result = get_world_2d().direct_space_state.intersect_ray(query)

	if not result.is_empty() and can_hit_target(result.collider) and not result.collider.is_in_group("no_bullet_collision"):
		#set bullet position to the exact collision location
		global_position = result.position
		
		#send hit_position as slighly inside the hit object
		var hit_position: Vector2 = result.position - result.normal # * 0.5 
		
		var target = result.collider
		hit_detected.emit(target, damage, bullet_owner, hit_position)
		queue_free()
		return

	global_position = end_position

func can_hit_target(target: Node) -> bool:
	if not is_instance_valid(target):
		return false

	# Allow hitting terrain or objects that aren't combat entities.
	if not target.has_method("get_team"):
		return true

	# Store the firing team's identity when the bullet is created.
	return bullet_team != target.get_team()
