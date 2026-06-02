extends Node2D

@onready var fire: Button = $Fire
@onready var move: Button = $Move
@onready var fire_label: Label = $FireLabel


func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)

#if the selected troop is a mortar, show the fire button
func _select_troop(troop_id: int, type: String, _location: String) -> void:
	if troop_id != 0 && type == "Mortar":
		fire.show()
		move.hide()
	else:
		fire.hide()
		move.hide()
		
	if type == "MortarFire":
		fire_label.show()
	else:
		fire_label.hide()

#sets the mortar to firing mode
func _on_fire_pressed() -> void:
	move.show()
	fire.hide()
	SignalBus.mortar_firing_mode.emit()

#sets the mortar to movement mode
func _on_move_pressed() -> void:
	fire.show()
	move.hide()
	SignalBus.mortar_movement_mode.emit()
