extends Node


func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)

func SelectTroop(id: int, type: String, location: String) -> void:
	if type == "Mortar":
		pass
	elif type == "TroopLeader":
		pass
	else:
		pass
