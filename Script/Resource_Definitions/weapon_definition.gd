extends Resource
class_name Weapon

@export var type: weapon_types
@export var level: int
@export var damage: int
@export var bullet_speed: int
@export var bullet_spread: int
@export var bullet: PackedScene
#eventually bullet sprite and hitbox

enum weapon_types {
	basic,
	piercing,
	tracking,
	explosive,
	lifesteal
}

func fire(player,direction):
	var new_bullet = bullet.instantiate()

	new_bullet.direction = direction.normalized().rotated(deg_to_rad(randf_range(-bullet_spread,bullet_spread)))
	new_bullet.speed = bullet_speed
	new_bullet.damage = damage
	new_bullet.bullet_owner = player

	new_bullet.hit_detected.connect(GameManager._on_bullet_hit_detected)

	player.get_parent().add_child(new_bullet)
	new_bullet.global_position = player.global_position
	new_bullet.rotation = new_bullet.direction.angle()
