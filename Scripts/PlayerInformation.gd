extends Node

var SelectedTroop: int
var AttackList: Dictionary = {}

func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)
	SignalBus.check_if_attacks_ready.connect(CheckIfAttackReady)

func SelectTroop(id: int, _type: String, _troop_location: String) -> void:
	SelectedTroop = id

func CheckIfAttackReady() -> void:
	for troop in GameManager.Players[multiplayer.get_unique_id()].Troops:
		if !AttackList.has(troop):
			return
	RPCFunctions.SendAttackList(multiplayer.get_unique_id(), AttackList.duplicate(true))
	AttackList = {}
