extends Entity

var team_core: Node = null
var has_command := false
var move_speed := 200.0
var movement_mode = MovementMode.DIRECT
var player_mode = PlayerMode.WEAPONS

var item_pickup_range := 500

var energy := 0

@onready var selectable: Selectable = $Selectable

var equipped_weapon: Weapon
var equipped_structure: Structure
@onready var available_structures: Array[Structure] = [equipped_structure]
@onready var available_weapons: Array[Weapon] = [equipped_weapon]

enum MovementMode {
	DIRECT,
	COMMAND
}

enum PlayerMode {
	WEAPONS,
	STRUCTURE_PLACEMENT
}

#movement and physics
func _physics_process(_delta: float) -> void:
	
	var selected = selectable.is_selected
	
	if selected:
		var mouse_pos = get_global_mouse_position()

		if Input.is_action_just_pressed("movement_mode_toggle"):
			movement_mode = (movement_mode + 1) % MovementMode.size() as MovementMode
			# set cursor to reflect movement mode
			if movement_mode == MovementMode.COMMAND:
				Input.set_default_cursor_shape(Input.CURSOR_CROSS)
			else:
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
		if movement_mode == MovementMode.DIRECT:
			if Input.is_action_pressed("move_command"):
				#clear navigation command first
				$NavigationAgent2D.target_position = Vector2.ZERO
				has_command = false
				var direction = global_position.direction_to(mouse_pos)
				velocity = direction * move_speed
			else:
				velocity = Vector2.ZERO
				
		else: if movement_mode == MovementMode.COMMAND:
			if Input.is_action_just_pressed("move_command"):
				$NavigationAgent2D.target_position = mouse_pos
				has_command = true
			if has_command:
				if $NavigationAgent2D.is_navigation_finished():
					velocity = Vector2.ZERO
					has_command = false
				else:
					var next_path_position = $NavigationAgent2D.get_next_path_position()
					var nav_point_direction = global_position.direction_to(next_path_position)
					
					velocity = nav_point_direction * move_speed
		
		look_at(mouse_pos)
		move_and_slide()

#weapons, abilites, stats...
func _process(_delta: float) -> void:
	var selected = selectable.is_selected
	
	if selected:
		
		if Input.is_action_just_pressed("player_mode_toggle"):
			player_mode = (player_mode + 1) % PlayerMode.size() as PlayerMode
			if player_mode == PlayerMode.WEAPONS:
				GameManager.preview_map.clear()
		
		match player_mode:
			PlayerMode.WEAPONS:
				if Input.is_action_just_pressed("action"):
					if equipped_weapon:
						var bullet_direction = global_position.direction_to(get_global_mouse_position())
						equipped_weapon.fire(self,bullet_direction)
				if Input.is_action_just_pressed("scroll_down"):
					var current_index = available_weapons.find(equipped_weapon)
					if current_index != -1:
						var next_index = (current_index + 1) % available_weapons.size()
						equipped_weapon = available_weapons[next_index]
					#print(equipped_weapon.display_name)
				if Input.is_action_just_pressed("scroll_up"):
					var current_index = available_weapons.find(equipped_weapon)
					if current_index != -1:
						var next_index = (current_index - 1) % available_weapons.size()
						equipped_weapon = available_weapons[next_index]
					#print(equipped_weapon.display_name)
			
			PlayerMode.STRUCTURE_PLACEMENT:
				#preview equipped structure
				if equipped_structure:
					GameManager.preview_structure(self,equipped_structure,get_global_mouse_position())
				#attempt to place equipped structure
				if Input.is_action_just_pressed("action"):
					if equipped_structure:
						GameManager.place_structure(self,equipped_structure,get_global_mouse_position())
				if Input.is_action_just_pressed("scroll_down"):
					var current_index = available_structures.find(equipped_structure)
					if current_index != -1:
						var next_index = (current_index + 1) % available_structures.size()
						equipped_structure = available_structures[next_index]
					#print(equipped_structure.display_name)
				if Input.is_action_just_pressed("scroll_up"):
					var current_index = available_structures.find(equipped_structure)
					if current_index != -1:
						var next_index = (current_index - 1) % available_structures.size()
						equipped_structure = available_structures[next_index]
					#print(equipped_structure.display_name)

func add_item(item, quantity):
	if item.item_type == 0:
		energy += quantity
	else:
		pass
