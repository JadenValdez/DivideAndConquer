extends Node2D

const COLOR_BUTTON = preload("res://Scenes/ColorButton.tscn")

@onready var ready_players: Label = $ReadyPlayers

@onready var current_color_background: ColorRect = $CurrentColor/CurrentColorBackground
@onready var current_color_name: Label = $CurrentColor/CurrentColorName

var color_column: int = 0
var color_row: int = 0

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
	SignalBus.update_ready_players_lobby.connect(_update_ready_players_lobby)
	SignalBus.update_color_buttons.connect(_update_color_buttons)
	
	create_color_buttons()

func create_color_buttons() -> void:
	color_row = 0
	color_column = 0
	for color in Colors.COLORS:
		var instance = COLOR_BUTTON.instantiate()
		
		instance.color_name = color
		instance.button_color = Colors.COLORS[color].Color
		instance.position = Vector2(100 + color_column * 150, 150 + color_row * 150)
		
		add_child(instance)
		
		color_column += 1
		if color_column >= 4:
			color_column = 0
			color_row += 1

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
	
	RPCFunctions.UpdateColorButtons.rpc()
	RPCFunctions.UpdateReadyPlayersLobby.rpc()
	
func _update_ready_players_lobby() -> void:
	GameManager.ReadyPlayers = 0
	for player in GameManager.Players:
		if GameManager.Players[player].Name != "None":
			GameManager.ReadyPlayers += 1
	ready_players.text = "Players Ready:
		" + str(GameManager.ReadyPlayers) + "/" + str(GameManager.TotalPlayers)

func _update_color_buttons() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Name == "None":
		current_color_background.modulate = Color(1, 1, 1, 1)
		current_color_name.text = "None"
	else:
		current_color_background.modulate = Colors.COLORS[GameManager.Players[multiplayer.get_unique_id()].Name].Color
		current_color_name.text = GameManager.Players[multiplayer.get_unique_id()].Name

func _on_start_game_pressed() -> void:
	RPCFunctions.StartGame.rpc()
