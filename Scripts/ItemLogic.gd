extends Node

var CurrentItem: String = "None"

func _ready() -> void:
	SignalBus.select_item.connect(_select_item)

func _select_item(item_name: String) -> void:
	CurrentItem = item_name
	match item_name:
		"None":
			pass
		"Medkit":
			SignalBus.show_troop_item_buttons.emit(item_name)
		"Upgraded Troop":
			SignalBus.show_troop_item_buttons.emit(item_name)
		"Jet Plane":
			SignalBus.show_plane_locations.emit(item_name)
		"Bomber Plane":
			SignalBus.show_plane_locations.emit(item_name)
		"Missile":
			SignalBus.show_plane_locations.emit(item_name)

func UsePlaneItem(location: String) -> void:
	MovementLogic.MoveableSpaces = TileNeighbors.NEIGHBORS[location]
	MovementLogic.CurrentSpace = "00"
	SignalBus.show_movement_spaces.emit()
	match CurrentItem:
		"Jet Plane":
			MovementLogic.CurrentAction = "Plane Item"
		"Bomber Plane":
			MovementLogic.CurrentAction = "Plane Item"
		"Missile":
			MovementLogic.CurrentAction = "Missile Item"

func PlanItemMove() -> void:
	pass
	
func DetonateMissile() -> void:
	pass
