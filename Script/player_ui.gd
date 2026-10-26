extends CanvasLayer

@onready var my_player = $"..".get_parent()
@onready var energy_label: Label = $EnergyLabel

func _ready() -> void:
	$CoreShop.visible = false
	$CoreShop/WeaponShop.visible = false
	$CoreShop/StructureShop.visible = false
	$CoreShop/WeaponShop.purchase_requested_from_shop.connect(_on_purchase_requested)
	$CoreShop/StructureShop.purchase_requested_from_shop.connect(_on_purchase_requested)

func _process(_delta: float) -> void:
	energy_label.text = "Energy: %s" % my_player.energy
	
	if my_player.selectable.is_selected:
		if $CoreShop.visible:
			$CoreShop.visible = false
	if my_player.team_core.selectable.is_selected:
		if !$CoreShop.visible:
			$CoreShop.visible = true
	else:
		$CoreShop.visible = false

func _on_weapon_shop_button_pressed() -> void:
	$CoreShop/Home.visible = false
	$CoreShop/WeaponShop.visible = true

func _on_structure_shop_button_pressed() -> void:
	$CoreShop/Home.visible = false
	$CoreShop/StructureShop.visible = true

func _on_back_button_pressed() -> void:
	$CoreShop/Home.visible = true
	$CoreShop/WeaponShop.visible = false
	$CoreShop/StructureShop.visible = false

func _on_deselect_pressed() -> void:
	SelectionManager.clear_selection()

func _on_purchase_requested(item: ShopItem) -> void:
	GameManager.purchase_item(item,my_player)
