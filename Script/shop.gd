extends PanelContainer

signal purchase_requested_from_shop(item: ShopItem)

@export var item_catalog: Array[ShopItem] = []

@export var item_button_scene: PackedScene

@onready var item_list: VBoxContainer = $VBoxContainer/ItemList

func _ready() -> void:
	populate_shop()

func populate_shop() -> void:
	for item in item_catalog:
		var item_button = item_button_scene.instantiate()
		item_list.add_child(item_button)
		item_button.setup(item)
		item_button.purchase_requested.connect(
			_on_purchase_requested
		)

func _on_purchase_requested(item: ShopItem) -> void:
	purchase_requested_from_shop.emit(item)

#signal from child buttons routes to this node's parent. This allows this shops script to remain versatile
