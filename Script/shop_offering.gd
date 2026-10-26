class_name ShopItemButton
extends Button

signal purchase_requested(item: ShopItem)

@onready var icon_rect: TextureRect = $HBoxContainer/Icon
@onready var name_label: Label = $HBoxContainer/VBoxContainer/ItemName
@onready var description_label: Label = $HBoxContainer/VBoxContainer/Description
@onready var cost_label: Label = $HBoxContainer/VBoxContainer/Cost

var item: ShopItem

func setup(shop_item: ShopItem) -> void:
	item = shop_item

	if not is_node_ready():
		await ready

	icon_rect.texture = item.icon
	name_label.text = item.display_name
	description_label.text = item.description
	cost_label.text = "%d Energy" % item.cost

func _on_pressed() -> void:
	purchase_requested.emit(item)
