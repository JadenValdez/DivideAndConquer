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
	
	
	neighbors = TileNeighbors.NEIGHBORS[tile_id]
	label.text = tile_id
	
	for id in GameManager.Players:
		if GameManager.Players[id].Territory == [tile_id]:
			color_rect.modulate = GameManager.Players[id].Color

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.select_tile.emit(tile_id)

func _get_tile_position(id: String) -> void:
	if id == tile_id:
		SignalBus.set_tile_position.emit(self.position)
		
func _show_placement_spaces(spaces: Array) -> void:
	place.hide()
	for id in spaces:
		if id == tile_id:
			place.show()
		
func _show_movement_spaces(spaces: Array, current_location: String) -> void:
	move.hide()
	pause.hide()
	for id in spaces:
		if id == tile_id:
			move.show()
	if current_location == tile_id:
		pause.show()

func _reset_tile_indicators() -> void:
	place.hide()
	move.hide()
	pause.hide()
	fire.hide()
