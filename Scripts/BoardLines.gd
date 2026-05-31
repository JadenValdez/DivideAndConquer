extends Node2D

var tile_position_var: Vector2
var position1: Vector2
var position2: Vector2


func _ready() -> void:
	SignalBus.set_tile_position.connect(_set_tile_position)
	draw_connections()

#draws a line between every neighboring tile
func draw_connections() -> void:
	for tile1 in TileNeighbors.CONNECTIONS:
		SignalBus.get_tile_position.emit(tile1)
		position1 = tile_position_var
		
		print(tile1)
		print(position1)
		
		for tile2 in TileNeighbors.CONNECTIONS[tile1]:
			SignalBus.get_tile_position.emit(tile2)
			position2 = tile_position_var
			
			print(tile2)
			print(position2)
			
			var line = Line2D.new()
			line.points = [position1, position2]
			line.width = 1
			line.default_color = Color(0, 0, 0, 1)
			line.z_index = -1
			add_child(line)

#gets the position for the chosen tile and saves it as a variable
func _set_tile_position(tile_position: Vector2) -> void:
	tile_position_var = tile_position
