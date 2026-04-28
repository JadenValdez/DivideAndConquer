extends Node

var TroopLocations: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SimulateConquest(attack_lists: Dictionary) -> void:
	TroopLocations = {}
	for player_id in attack_lists:
		for troop in attack_lists[player_id]:
			pass
