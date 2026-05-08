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
	SignalBus.get_round_resources.connect(_get_round_resources)
	
	
	neighbors = TileNeighbors.NEIGHBORS[tile_id]
	label.text = tile_id
	
	for id in GameManager.Players:
		if GameManager.Players[id].Territory == [tile_id]:
			color_rect.modulate = GameManager.Players[id].Color
			LocationInfo.Tiles[tile_id] = GameManager.Players[id].Name

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.select_tile.emit(tile_id)

func _get_tile_position(id: String) -> void:
	if id == tile_id:
		SignalBus.set_tile_position.emit(self.position)
		
func _show_placement_spaces() -> void:
	place.hide()
	for id in GameManager.Players[multiplayer.get_unique_id()].Territory:
		if id == tile_id:
			place.show()
		
func _show_movement_spaces() -> void:
	move.hide()
	pause.hide()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			move.show()
	if MovementLogic.CurrentSpace == tile_id:
		pause.show()

func _mortar_firing_mode() -> void:
	move.hide()
	pause.hide()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			fire.show()
	if MovementLogic.CurrentSpace == tile_id:
		pause.show()
			
func _mortar_movement_mode() -> void:
	fire.hide()
	for id in MovementLogic.MoveableSpaces:
		if id == tile_id:
			move.show()

func _reset_tile_indicators() -> void:
	place.hide()
	move.hide()
	pause.hide()
	fire.hide()

func _get_round_resources() -> void:
	if LocationInfo.Tiles[tile_id] == GameManager.Players[multiplayer.get_unique_id()].Name:
		SignalBus.add_resources.emit(tile_type)
