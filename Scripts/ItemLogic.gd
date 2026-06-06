extends Node

var CurrentItem: String = "None"

func _ready() -> void:
	SignalBus.select_item.connect(_select_item)

#if the player uses a plane item, create a new troop tab for it
#if the player uses an instant item, then show the "use" button for any valid troops
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
			SignalBus.craft_troop.emit("Jet Plane", 4)
		"Bomber Plane":
			SignalBus.craft_troop.emit("Bomber Plane", 4)
		"Missile":
			SignalBus.craft_troop.emit("Missile", 4)

#outdated
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

#outdated
func PlanItemMove() -> void:
	pass
	
#outdated
func DetonateMissile() -> void:
	pass
