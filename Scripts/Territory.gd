extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

@onready var place: Node2D = $Place
@onready var move: Node2D = $Move
@onready var pause: Node2D = $Pause
@onready var fire: Node2D = $Fire

@export var tile_id: String
@export var tile_type: String
@export var neighbors: Array

var current_owner: Dictionary = {
	"Name": "None",
	"Color": Color(1, 1, 1, 1)
}

func _ready() -> void:
	SignalBus.get_tile_position.connect(_get_tile_position)
	SignalBus.show_placement_spaces.connect(_show_placement_spaces)
	SignalBus.show_movement_spaces.connect(_show_movement_spaces)
	SignalBus.reset_tile_indicators.connect(_reset_tile_indicators)
	
	SignalBus.mortar_firing_mode.connect(_mortar_firing_mode)
	SignalBus.mortar_movement_mode.connect(_mortar_movement_mode)
	
	SignalBus.update_territory_colors.connect(_update_territory_colors)
	SignalBus.get_round_resources.connect(_get_round_resources)
	
	SignalBus.show_plane_locations.connect(_show_plane_locations)
	
	neighbors = TileNeighbors.NEIGHBORS[tile_id]
	label.text = tile_id
	
	for id in GameManager.Players:
		if GameManager.Players[id].Territory == [tile_id]:
			color_rect.modulate = GameManager.Players[id].Color
			LocationInfo.Tiles[tile_id] = GameManager.Players[id].Name

#select this tile when clicked
func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				#if ItemLogic.CurrentItem == "Jet Plane" || ItemLogic.CurrentItem == "Bomber Plane" || ItemLogic.CurrentItem == "Missile":
					#if place.visible:
						#ItemLogic.UsePlaneItem(tile_id)
					#else:
						#SignalBus.select_tile.emit(tile_id)
				#else:
				SignalBus.select_tile.emit(tile_id)

#get the position of this tile for board lines
func _get_tile_position(id: String) -> void:
	if id == tile_id:
		SignalBus.set_tile_position.emit(self.position)
		
#shows the placement indicator for owned tiles when placing a unit
func _show_placement_spaces() -> void:
	_reset_tile_indicators()
	for id in GameManager.Players[multiplayer.get_unique_id()].Territory:
		if id == tile_id:
			place.show()
		
#shows the movement indicator for nearby tiles when moving a unit
#shows the pause indicator for the current tile when moving a unit
func _show_movement_spaces() -> void:
	_reset_tile_indicators()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			move.show()
	if MovementLogic.CurrentSpace == tile_id:
		if MovementLogic.CurrentAction == "Missile Move":
			fire.show()
		else:
			pause.show()

#shows the fire indicator for nearby tiles when in mortar firing mode
func _mortar_firing_mode() -> void:
	_reset_tile_indicators()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			fire.show()
	if MovementLogic.CurrentSpace == tile_id:
		pause.show()
			
#shows the movement indicator for nearby tiles when in mortar movement mode
func _mortar_movement_mode() -> void:
	_reset_tile_indicators()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			move.show()
	if MovementLogic.CurrentSpace == tile_id:
		pause.show()

#resetss all tile indicators
func _reset_tile_indicators() -> void:
	place.hide()
	move.hide()
	pause.hide()
	fire.hide()

#updates the tile's color based on who owns it
func _update_territory_colors() -> void:
	if LocationInfo.Tiles[tile_id] == "None":
		color_rect.modulate = Color(1, 1, 1, 1)
	else:
		color_rect.modulate = Colors.COLORS[LocationInfo.Tiles[tile_id]].Color

#add resources to the player that owns this tile that depends on this tile's type
func _get_round_resources() -> void:
	if LocationInfo.Tiles[tile_id] == GameManager.Players[multiplayer.get_unique_id()].Name:
		SignalBus.add_resources.emit(tile_type)

#not implemented yet
func _show_plane_locations(item_name: String) -> void:
	place.hide()
	move.hide()
	pause.hide()
	for id in GameManager.Players[multiplayer.get_unique_id()].Territory:
		if id == tile_id:
			place.show()
