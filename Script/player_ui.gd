extends CanvasLayer

@onready var my_player = $"..".get_parent()
@onready var energy_label: Label = $EnergyLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	energy_label.text = "Energy: %s" % my_player.energy
