extends Node2D

var tab_number: int = 0
@onready var ready_button: Button = $Ready
@onready var ready_players_label: Label = $ReadyPlayersLabel

@onready var undo: Button = $Undo

@onready var craft: Button = $Craft
@onready var crafting_window: Node2D = $CraftingWindow

const TROOP_TAB = preload("res://Scenes/TroopTab.tscn")

func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)
	SignalBus.update_ready_players_board.connect(_update_ready_players_board)
	
	SignalBus.troop_defeated.connect(_troop_defeated)
	SignalBus.craft_troop.connect(_craft_troop)
	
	SignalBus.start_next_round.connect(_start_next_round)
	
	GameManager.ReadyPlayers = 0
	ready_players_label.text = "Ready: 
		" + str(GameManager.ReadyPlayers) + "/" + str(GameManager.TotalPlayers)
	create_initial_units()

#creates a troop tab for each of the player's starting troops
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

#shows the undo button when selecting a troop
func _select_troop(id: int, _type: String, _location: String) -> void:
	if id == 0:
		undo.hide()
	else:
		undo.show()

#tries to undo a move when the button is pressed
func _on_undo_pressed() -> void:
	SignalBus.undo_move.emit()

#readies the player if they are not ready, and unreadies if they are ready
func _on_ready_pressed() -> void:
	if ready_button.text == "Ready Up":
		SignalBus.select_troop.emit(0, "Troop", "X")
		ready_button.text = "Cancel"
		RPCFunctions.ReadyPlayer.rpc()
		
	else:
		SignalBus.select_troop.emit(0, "Troop", "X")
		ready_button.text = "Ready Up"
		RPCFunctions.NotReadyPlayer.rpc()

#updated the number that tracks the amount of ready players
func _update_ready_players_board() -> void:
	ready_players_label.text = "Ready: 
		" + str(GameManager.ReadyPlayers) + "/" + str(GameManager.TotalPlayers)

#decreases the amount of troop tabs by 1 when a troop is defeated
func _troop_defeated(_defeated_tab_number: int) -> void:
	tab_number -= 1

#button to open the craft window
func _on_craft_pressed() -> void:
	if craft.text == "Craft":
		craft.text = "Close"
		crafting_window.show()
	else:
		craft.text = "Craft"
		crafting_window.hide()

#creates a new troop tab based on its type and how many the player already has
func _craft_troop(troop_type: String, tp: int) -> void:
	var instance = TROOP_TAB.instantiate()
	instance.troop_id = Colors.COLORS[GameManager.Players[multiplayer.get_unique_id()].Name].Prefix * 1000 + GameManager.Players[multiplayer.get_unique_id()].UnitID
	GameManager.Players[multiplayer.get_unique_id()].UnitID += 1
	instance.troop_type = troop_type
	instance.troop_tp = tp
	instance.location = "None"
	instance.recently_crafted = true
	
	instance.tab_number = tab_number
	instance.tab_color = GameManager.Players[multiplayer.get_unique_id()].Color
	add_child(instance)
	
	tab_number += 1

#resets the ready button on round start
func _start_next_round() -> void:
	ready_button.text = "Ready Up"
	
