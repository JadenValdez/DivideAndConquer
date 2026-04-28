extends Node2D

var tab_number: int = 0
@onready var ready_button: Button = $Ready
@onready var ready_players_label: Label = $ReadyPlayersLabel

const TROOP_TAB = preload("res://Scenes/TroopTab.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_ready_players_board.connect(_update_ready_players_board)
	GameManager.ReadyPlayers = 0
	ready_players_label.text = "Ready: 
		" + str(GameManager.ReadyPlayers) + "/" + str(GameManager.TotalPlayers)
	create_initial_units()

func create_initial_units() -> void:
	tab_number = 0
	for troop in GameManager.Players[multiplayer.get_unique_id()].Troops:
		
		var instance = TROOP_TAB.instantiate()
		instance.troop_id = troop
		instance.troop_type = GameManager.Players[multiplayer.get_unique_id()].Troops[troop].Type
		instance.troop_tp = GameManager.Players[multiplayer.get_unique_id()].Troops[troop].TP
		instance.location = Colors.COLORS[GameManager.Players[multiplayer.get_unique_id()].Name].Base
		instance.recently_crafted = false
		
		instance.tab_number = tab_number
		instance.tab_color = GameManager.Players[multiplayer.get_unique_id()].Color
		add_child(instance)
		
		tab_number += 1


func _on_undo_pressed() -> void:
	SignalBus.undo_move.emit()


func _on_ready_pressed() -> void:
	if ready_button.text == "Ready Up":
		RPCFunctions.ReadyPlayer()
		ready_button.text = "Cancel"
	else:
		ready_button.text = "Ready Up"
		RPCFunctions.NotReadyPlayer()

func _update_ready_players_board() -> void:
	ready_players_label.text = "Ready: 
		" + str(GameManager.ReadyPlayers) + "/" + str(GameManager.TotalPlayers)
