extends Node

var SelectedTroop: int
var AttackList: Dictionary = {}

func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)
	SignalBus.check_if_attacks_ready.connect(CheckIfAttackReady)

#selects a troop when clicking on its corresponding troop tab
func SelectTroop(id: int, _type: String, _troop_location: String) -> void:
	SelectedTroop = id

#sends the attack list when moves from all the player's troops have been recieved
func CheckIfAttackReady() -> void:
	for troop in GameManager.Players[multiplayer.get_unique_id()].Troops:
		if !AttackList.has(troop):
			return
	RPCFunctions.SendAttackList.rpc(GameManager.Players[multiplayer.get_unique_id()].Name, AttackList.duplicate(true))
	AttackList = {}
