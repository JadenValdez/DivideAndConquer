extends Node2D

var tab_number: int = 0
@onready var ready_button: Button = $Ready
@onready var ready_players_label: Label = $ReadyPlayersLabel

@onready var undo: Button = $Undo

@onready var craft: Button = $Craft
@onready var crafting_window: Node2D = $CraftingWindow

const TROOP_TAB = preload("res://Scenes/TroopTab.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)
	SignalBus.update_ready_players_board.connect(_update_ready_players_board)
	
	SignalBus.troop_defeated.connect(_troop_defeated)
	SignalBus.craft_troop.connect(_craft_troop)
	
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

func _select_troop(id: int, _type: String, _location: String) -> void:
	if id == 0:
		undo.hide()
	else:
		undo.show()

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

func _troop_defeated(_defeated_tab_number: int) -> void:
	tab_number -= 1


func _on_craft_pressed() -> void:
	if craft.text == "Craft":
		craft.text = "Close"
		crafting_window.show()
	else:
		craft.text = "Craft"
		crafting_window.hide()

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
