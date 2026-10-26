extends Entity

@export var max_health: int = 1000
@export var level: int = 1

@onready var selectable: Selectable = $Selectable

var health: int
var team_members: Array[Entity] = []

var spawn_position: Vector2:
	get:
		return global_position
var is_destroyed: bool = false
var blank_player_scene = preload("res://Scene/Player.tscn")

# new player equipment
var player_starting_weapon: Weapon = preload("res://Resource/weapons/weapon_starter.tres")
var player_starting_structure: Structure = preload("res://Resource/structure/wall.tres")

func _ready() -> void:
	health = max_health
	
	#spawn initial players
	var new_player = blank_player_scene.instantiate()
	new_player.team = get_team()
	new_player.equipped_weapon = player_starting_weapon
	new_player.equipped_structure = player_starting_structure
	new_player.team_core = self
	add_child(new_player)
	new_player.global_position = spawn_position
	add_team_member(new_player)

func take_damage(amount: int, source: Node = null) -> void:
	if is_destroyed or amount <= 0:
		return
	health = maxi(health - amount, 0)
	if health == 0:
		destroy_core(source)
func heal(amount: int) -> void:
	if is_destroyed or amount <= 0:
		return
	health = mini(health + amount, max_health)
func add_team_member(member: Entity) -> void:
	if not is_instance_valid(member):
		return
	if team_members.has(member):
		return
	team_members.append(member)
func remove_team_member(member: Entity) -> void:
	if not team_members.has(member):
		return
func destroy_core(source: Node = null) -> void:
	if is_destroyed:
		return
	is_destroyed = true
