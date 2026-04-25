extends Node

var SelectedTroop: int
var CurrentSpace: String
var MoveableSpaces: Array

var CurrentAction: String = "None"

func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)
	SignalBus.select_tile.connect(SelectTile)

func SelectTroop(troop_id: int, type: String, location: String) -> void:
	
	SelectedTroop = troop_id
	if troop_id == 0:
		SignalBus.reset_tile_indicators.emit()
		return
	
	if type == "Mortar":
		pass
		#allow switching between firing mode and moving mode
	
	if location == "None":
		CurrentAction = "Place"
		SignalBus.show_placement_spaces.emit(GameManager.Players[multiplayer.get_unique_id()].Territory)
		
	else:
		CurrentAction = "Move"
		CurrentSpace = location
		MoveableSpaces = TileNeighbors.NEIGHBORS[location]
		SignalBus.show_movement_spaces.emit(MoveableSpaces, CurrentSpace)

func SelectTile(tile_id: String) -> void:
	if CurrentAction == "Place":
		for space in GameManager.Players[multiplayer.get_unique_id()].Territory:
			if tile_id == space:
				SignalBus.plan_troop_move.emit(SelectedTroop, "Place", tile_id)
	elif CurrentAction == "Move":
		if tile_id == CurrentSpace:
			SignalBus.plan_troop_move.emit(SelectedTroop, "Pause", tile_id)
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					SignalBus.plan_troop_move.emit(SelectedTroop, "Move", tile_id)
