extends Area2D
class_name ItemPickup

var item: Item
var quantity: int = 1
var lerp_speed = 0.15
@onready var all_players = get_tree().get_nodes_in_group("Players")

func _ready() -> void:
	if item != null:
		# Update the visual to match the item.
		$Sprite2D.texture = item.icon

func _process(_delta: float) -> void:
	var closest_player = all_players[0]
	var closest_distance: float = INF
	
	#move toward closest player in pickup range
	for player in all_players:
		var distance_to_this_player = global_position.distance_squared_to(player.global_position)
		if (distance_to_this_player < closest_distance):
			closest_distance = distance_to_this_player
			closest_player = player
		if distance_to_this_player < closest_player.item_pickup_range:
				global_position = lerp(global_position, closest_player.global_position, lerp_speed)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Players"):
		return

	body.add_item(item, quantity)
	queue_free()
