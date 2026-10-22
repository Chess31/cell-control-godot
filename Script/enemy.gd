extends Entity

@export var detection_range: float = 300.0
@export var attack_distance: float = 60.0
@export var move_speed: float = 100.0
@export var stopping_tolerance: float = 8.0
var weapon: Weapon = preload("res://Resource/weapons/basic_enemy_weapon.tres")

@onready var fire_rate_timer: Timer = $Fire_Rate_Timer

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var target: Node2D = null
var desired_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	navigation_agent.avoidance_enabled = true
	navigation_agent.path_desired_distance = 8.0
	navigation_agent.target_desired_distance = stopping_tolerance

func _physics_process(_delta: float) -> void:
	find_closest_player()

	if not is_instance_valid(target):
		desired_velocity = Vector2.ZERO
		navigation_agent.velocity = desired_velocity
		return

	var distance_squared := global_position.distance_squared_to(target.global_position)

	if distance_squared > detection_range * detection_range:
		desired_velocity = Vector2.ZERO
		navigation_agent.velocity = desired_velocity
		return

	var distance := sqrt(distance_squared)
	var direction_to_player := global_position.direction_to(target.global_position)

	# Stop at the desired shooting distance.
	if distance <= attack_distance:
		desired_velocity = Vector2.ZERO
		navigation_agent.velocity = desired_velocity
		velocity = Vector2.ZERO
		return

	# Set a destination attack_distance away from the player.
	var destination := target.global_position - (direction_to_player * attack_distance)

	navigation_agent.target_position = destination

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	desired_velocity = direction * move_speed
	navigation_agent.velocity = desired_velocity

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func find_closest_player() -> void:
	var closest_distance_squared := INF
	target = null

	for player in get_tree().get_nodes_in_group("Players"):
		if not is_instance_valid(player) or not player is Node2D:
			continue

		var distance_squared := global_position.distance_squared_to(
			player.global_position
		)

		if distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			target = player

func take_damage(damage,source):
	queue_free()

func _on_fire_rate_timer_timeout() -> void:
	if not is_instance_valid(target):
		return

	var distance := global_position.distance_to(target.global_position)

	if distance > attack_distance+stopping_tolerance or distance > detection_range:
		return

	var bullet_direction := global_position.direction_to(target.global_position)

	weapon.fire(self, bullet_direction)
