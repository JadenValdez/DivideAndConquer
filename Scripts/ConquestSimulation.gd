extends Node

var TroopLocations: Dictionary = {}
var TroopStatus: Dictionary = {}

func _ready() -> void:
	pass # Replace with function body.
	
#"Team": GameManager.Players[multiplayer.get_unique_id()].Name,
#"Type": troop_type,
#"TP": troop_tp,
#"Location": location, 
#"FireMove": fire_move,
#"M1": m_1_location.text, 
#"M2": m_2_location.text, 
#"M3": m_3_location.text, 
#"M4": m_4_location.text

func SimulateConquest(attack_lists: Dictionary) -> void:
	
	TroopLocations = {}
	for player_id in attack_lists:
		for troop in attack_lists[player_id]:
			if attack_lists[player_id][troop].Location != "None":
				TroopLocations[attack_lists[player_id][troop].Location][troop] = {
					"Team": attack_lists[player_id][troop].Team,
					"Type": attack_lists[player_id][troop].Type,
					"TP": attack_lists[player_id][troop].TP
				}
				
				TroopStatus[troop] = "Active"
	
	for location in TroopLocations:
		for troop in TroopLocations[location]:
			if attack_lists[player_id][troop].M1 != "X":
				if attack_lists[player_id][troop].FireMove == 1:
					pass
				else:
					pass
