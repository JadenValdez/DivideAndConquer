extends Node2D

const COLOR_BUTTON = preload("res://Scenes/ColorButton.tscn")

@onready var ready_players: Label = $ReadyPlayers
var color_column: int = 0
const starting_troops: Dictionary = {
	0: "TroopLeader",
	1: "TroopLeader",
	2: "Troop",
	3: "Troop",
	4: "Troop",
	5: "Troop",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_color.connect(_select_color)
	create_color_buttons()

func create_color_buttons() -> void:
	color_column = 0
	for color in Colors.COLORS:
		var instance = COLOR_BUTTON.instantiate()
		
		instance.color_name = color
		instance.button_color = Colors.COLORS[color].Color
		instance.position = Vector2(250 + color_column * 50, 250)
		
		add_child(instance)
		
		color_column += 1

func _select_color(id: int, color_name: String) -> void:
	GameManager.Players[id].Name = color_name
	GameManager.Players[id].Color = Colors.COLORS[color_name].Color
	GameManager.Players[id].Territory = [Colors.COLORS[color_name].Base]
	GameManager.Players[id].Troops = {}
	for troop_id in starting_troops:
		GameManager.Players[id].Troops[(Colors.COLORS[color_name].Prefix * 1000 + troop_id)] = {
			"Type": starting_troops[troop_id],
			"TP": UnitsInformation.Units[starting_troops[troop_id]].TP
		}
	
	SignalBus.update_color_buttons.emit()
