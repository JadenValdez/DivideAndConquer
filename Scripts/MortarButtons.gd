extends Node2D

@onready var fire: Button = $Fire
@onready var move: Button = $Move

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)

func _select_troop(troop_id: int, type: String, _location: String) -> void:
	if troop_id != 0 && type == "Mortar":
		fire.show()
		move.hide()
	else:
		fire.hide()
		move.hide()

func _on_fire_pressed() -> void:
	move.show()
	fire.hide()
	SignalBus.mortar_firing_mode.emit()

func _on_move_pressed() -> void:
	fire.show()
	move.hide()
	SignalBus.mortar_movement_mode.emit()
