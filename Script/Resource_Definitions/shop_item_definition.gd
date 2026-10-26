class_name ShopItem
extends Resource

enum CATAGORY {
	WEAPON,
	STRUCTURE,
	TECHNOLOGY
}

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 10
@export var category: CATAGORY

# Assign the relevant resource in the Inspector.
@export var weapon: Weapon
@export var structure: Structure
#@export var technology: TechDefinition
