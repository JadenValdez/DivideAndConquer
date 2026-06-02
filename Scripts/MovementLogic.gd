extends Node

var SelectedTroop: int
var CurrentSpace: String
var MoveableSpaces: Array

var CurrentAction: String = "None"

func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)
	SignalBus.select_tile.connect(SelectTile)
	
	SignalBus.mortar_firing_mode.connect(MortarFiringMode)
	SignalBus.mortar_movement_mode.connect(MortarMovementMode)

#if a troop is selcted, show the relevant indicators on nearby tiles
func SelectTroop(troop_id: int, type: String, location: String) -> void:
	
	SelectedTroop = troop_id
	
	#if no troop is selected, reset the tile indicators
	if troop_id == 0:
		SignalBus.reset_tile_indicators.emit()
		return
	
	#if the mortar is in firing mode, show the fire indicator on nearby tiles
	if type == "MortarFire":
		CurrentAction = "Fire"
		MoveableSpaces = TileNeighbors.NEIGHBORS[location]
		SignalBus.mortar_firing_mode.emit()
		return
	
	if location == "None":
		CurrentAction = "Place"
		SignalBus.show_placement_spaces.emit()
		
	else:
		CurrentAction = "Move"
		CurrentSpace = location
		MoveableSpaces = TileNeighbors.NEIGHBORS[location]
		SignalBus.show_movement_spaces.emit()

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
	elif CurrentAction == "Fire":
		if tile_id == CurrentSpace:
			SignalBus.plan_troop_move.emit(SelectedTroop, "Pause", tile_id)
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					SignalBus.plan_troop_move.emit(SelectedTroop, "Fire", tile_id)
	elif CurrentAction == "Plane Item":
		for space in MoveableSpaces:
			if tile_id == space:
				ItemLogic.PlanItemMove()
	elif CurrentAction == "Missile Item":
		if tile_id == CurrentSpace:
			ItemLogic.DetonateMissile()
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					ItemLogic.PlanItemMove()
					
func MortarFiringMode() -> void:
	CurrentAction = "Fire"
	
func MortarMovementMode() -> void:
	CurrentAction = "Move"
	
