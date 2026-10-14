extends Resource
class_name LootTable

@export var rolls: int = 1
@export var drops: Array[TableEntry] = []

func roll_loot() -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for i in rolls:
		var entry := _pick_entry()

		var quantity := randi_range(
			entry.min_quantity,
			maxi(entry.min_quantity, entry.max_quantity)
		)

		results.append({
			"item": entry.item,
			"quantity": quantity
		})

	return results


func _pick_entry() -> TableEntry:
	#total_weight system allows for rarer drops than 1 in 100
	var total_weight := 0
	
	#get total weight of all entries
	for entry in drops:
		total_weight += entry.weight
	
	#pick number within total weight
	var roll := randi_range(1, total_weight)

	for entry in drops:
		roll -= entry.weight

		if roll <= 0:
			return entry

	return null
