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
	
	#if the troop hasn't been placed yet, show the place indicator on owned tiles
	if location == "None":
		CurrentAction = "Place"
		SignalBus.show_placement_spaces.emit()
		
	#if the troop is a plane item, show the movement indicators on nearby tiles
	elif type == "Jet Plane" || type == "Bomber Plane" || type == "Missile":
		CurrentAction = "Move"
		if type == "Missile":
			CurrentSpace = location
			CurrentAction = "Missile Move"
		else:
			CurrentSpace = "00"
		MoveableSpaces = TileNeighbors.NEIGHBORS[location]
		SignalBus.show_movement_spaces.emit()
		
	#else, show the movement indicators on nearby tiles, and the pause indicator on the current tile
	else:
		CurrentAction = "Move"
		CurrentSpace = location
		MoveableSpaces = TileNeighbors.NEIGHBORS[location]
		SignalBus.show_movement_spaces.emit()

#when selecting a tile, save it as a move depending on the current action
func SelectTile(tile_id: String) -> void:
	
	#if placing a troop, set its location to the chosen tile
	if CurrentAction == "Place":
		for space in GameManager.Players[multiplayer.get_unique_id()].Territory:
			if tile_id == space:
				SignalBus.plan_troop_move.emit(SelectedTroop, "Place", tile_id)
				
	#if moving a troop, save the tile location for that move
	elif CurrentAction == "Move":
		if tile_id == CurrentSpace:
			SignalBus.plan_troop_move.emit(SelectedTroop, "Pause", tile_id)
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					SignalBus.plan_troop_move.emit(SelectedTroop, "Move", tile_id)
					
	#if moving a troop, save the tile location for that move
	elif CurrentAction == "Missile Move":
		if tile_id == CurrentSpace:
			SignalBus.plan_troop_move.emit(SelectedTroop, "Detonate", tile_id)
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					SignalBus.plan_troop_move.emit(SelectedTroop, "Move", tile_id)
					
	#if firing a mortar, save the tile location for a mortar shot on that move
	elif CurrentAction == "Fire":
		if tile_id == CurrentSpace:
			SignalBus.plan_troop_move.emit(SelectedTroop, "Pause", tile_id)
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					SignalBus.plan_troop_move.emit(SelectedTroop, "Fire", tile_id)
					
	#to be implemented
	elif CurrentAction == "Plane Item":
		for space in MoveableSpaces:
			if tile_id == space:
				ItemLogic.PlanItemMove()
				
	#to be implemented
	elif CurrentAction == "Missile Item":
		if tile_id == CurrentSpace:
			ItemLogic.DetonateMissile()
		else:
			for space in MoveableSpaces:
				if tile_id == space:
					ItemLogic.PlanItemMove()
					
#set the current action to mortar firing
func MortarFiringMode() -> void:
	CurrentAction = "Fire"
	
#set the current action to mortar movement
func MortarMovementMode() -> void:
	CurrentAction = "Move"
	
