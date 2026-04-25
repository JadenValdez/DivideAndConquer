extends Node2D

var tab_number: int = 0

const TROOP_TAB = preload("res://Scenes/TroopTab.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_initial_units()

func create_initial_units() -> void:
	tab_number = 0
	for troop in GameManager.Players[multiplayer.get_unique_id()].Troops:
		
		var instance = TROOP_TAB.instantiate()
		instance.troop_id = troop
		instance.troop_type = GameManager.Players[multiplayer.get_unique_id()].Troops[troop].Type
		instance.troop_tp = GameManager.Players[multiplayer.get_unique_id()].Troops[troop].TP
		instance.location = Colors.COLORS[GameManager.Players[multiplayer.get_unique_id()].Name].Base
		
		instance.tab_number = tab_number
		instance.tab_color = GameManager.Players[multiplayer.get_unique_id()].Color
		add_child(instance)
		
		tab_number += 1
