extends Node2D

@onready var map: TileMapLayer = get_tree().current_scene.get_node("Map").get_child(0)
@onready var preview_map: TileMapLayer = get_tree().current_scene.get_node("Map").get_child(1)

var tile_healths: Dictionary = {}

var item_pickup_scene: PackedScene = preload("res://Scene/item_pickup.tscn")

var tiles_occupied_by_structures: Dictionary = {}


#     GLOBAL SYSTEMS AND FUNCTIONS     #


func _on_bullet_hit_detected(target,damage,source,hit_position):
	if target.has_method("take_damage"):
		target.take_damage(damage,source)
	elif target == map:
		damage_tile(hit_position,damage)

func damage_tile(hit_position,damage):
	#find coords of hit tile
	var local_position = map.to_local(hit_position)
	var tile_coords: Vector2i = map.local_to_map(local_position)
	#print("Tile Hit! Coords: %s" % tile_coords)
	
	#ignore empty cells
	if map.get_cell_source_id(tile_coords) == -1:
		return
	
	#get default health from hit tile's custom data
	var tile_data: TileData = map.get_cell_tile_data(tile_coords)
	var default_health: int = tile_data.get_custom_data("Health")
	
	#init tile health in dictionary if not there yet
	if not tile_healths.has(tile_coords):
		tile_healths[tile_coords] = default_health
	
	#apply damage to tile health, destory if zero
	tile_healths[tile_coords] -= damage
	if tile_healths[tile_coords] <= 0:
		tile_healths.erase(tile_coords)
		map.set_cell(tile_coords,0,Vector2(0,0))
		#spawn loot from this tile
		var tile_loot_table: LootTable = tile_data.get_custom_data("Loot_Table")
		spawn_loot_from_table(tile_loot_table, hit_position)

func spawn_loot_from_table(loot_table: LootTable, spawn_position: Vector2):
	if loot_table == null:
		return
	
	var results := loot_table.roll_loot()
	
	for drop in results:
		var item_pickup := item_pickup_scene.instantiate() as ItemPickup
		
		#each drop called roll_loot, which returns Array[TableEntry]
		item_pickup.item = drop["item"]
		item_pickup.quantity = drop["quantity"]
		item_pickup.global_position = spawn_position
		
		get_tree().current_scene.add_child(item_pickup)

func preview_structure(_structure_owner: CharacterBody2D, structure: Structure, placement_position: Vector2):
	var preview_instance = structure.structure_scene.instantiate()
	
	var preview_layer = preview_instance.get_node("Structure_Footprint")
	var preview_pattern: TileMapPattern = preview_layer.get_pattern(preview_layer.get_used_cells())

	# Convert the given position to the map's local coordinates.
	var local_position = map.to_local(placement_position)
	var anchor_cell = map.local_to_map(local_position)

	var cells = get_structure_footprint_cells(anchor_cell, preview_pattern)
	var can_place = check_can_place_structure(cells)

	preview_map.clear()

	# Green if valid, red if invalid
	var highlight_tile = Vector2i(0, 2) if can_place else Vector2i(1, 2)

	for cell in cells:
		preview_map.set_cell(cell, 0, highlight_tile)

	preview_instance.free()

func place_structure(structure_owner: CharacterBody2D, structure: Structure, placement_position: Vector2) -> bool:

	if structure_owner.energy < structure.energy_cost:
		return false

	var new_structure = structure.structure_scene.instantiate()
	var footprint_layer = new_structure.get_node("Structure_Footprint")
	var pattern: TileMapPattern = footprint_layer.get_pattern(footprint_layer.get_used_cells())

	var local_position = map.to_local(placement_position)
	var anchor_cell = map.local_to_map(local_position)

	var cells = get_structure_footprint_cells(anchor_cell, pattern)

	if not check_can_place_structure(cells):
		new_structure.free()
		return false

	structure_owner.energy -= structure.energy_cost

	map.add_child(new_structure)
	new_structure.global_position = map.to_global(map.map_to_local(anchor_cell))

	# Register exactly the cells that were checked
	for cell in cells:
		tiles_occupied_by_structures[cell] = new_structure

	return true

func check_can_place_structure(cells: Array[Vector2i]) -> bool:
	for cell in cells:
		# Check terrain collision
		if map.get_used_cells_by_id(0, Vector2i(1, 0)).has(cell):
			return false

		# Check structure collision
		if tiles_occupied_by_structures.has(cell):
			return false

	return true

func get_structure_footprint_cells(anchor_cell: Vector2i, pattern: TileMapPattern) -> Array[Vector2i]:
	#normalized to the actual world tile coords via pattern mapping
	
	var cells: Array[Vector2i] = []
	
	for pattern_cell in pattern.get_used_cells():
		var cell = map.map_pattern(
			anchor_cell,
			pattern_cell,
			pattern
		)
		cells.append(cell)
	
	return cells
