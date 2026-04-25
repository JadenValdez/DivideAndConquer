extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

@export var tile_id: String
@export var tile_type: String
@export var neighbors: Array

var current_owner: Dictionary = {
	"Name": "None",
	"Color": Color(1, 1, 1, 1)
}

func _ready() -> void:
	SignalBus.get_tile_position.connect(_get_tile_position)
	
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
