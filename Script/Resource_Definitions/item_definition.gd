extends Resource
class_name Item

@export var item_id: StringName
@export var display_name: String
@export var icon: Texture2D
#@export var pickup_color: Color = Color.CYAN
@export var item_type: ItemType = ItemType.CURRENCY

enum ItemType {
	CURRENCY,
	CONSUMABLE,
	PLACEABLE,
	MATERIAL
}
