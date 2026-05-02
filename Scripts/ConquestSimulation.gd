extends Node

var TroopLocations: Dictionary = {}
var LocationBattles: Dictionary = {}
var TroopInfo: Dictionary = {}

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
	
	TroopInfo = {}
	TroopLocations = {}
	
	#puts each troop at their locations
	for team in attack_lists:
		for troop in attack_lists[team]:
			TroopInfo[troop] = {
				"Team": attack_lists[team][troop].Team,
				"Type": attack_lists[team][troop].Type,
				"TP": attack_lists[team][troop].TP,
				"FireMove": attack_lists[team][troop].FireMove,
				"M1": attack_lists[team][troop].M1, 
				"M2": attack_lists[team][troop].M2, 
				"M3": attack_lists[team][troop].M3, 
				"M4": attack_lists[team][troop].M4
			}
			
			
			if attack_lists[team][troop].Location != "None":
				
				if !TroopLocations.has(attack_lists[team][troop].Location):
					TroopLocations[attack_lists[team][troop].Location] = {}
					
				TroopLocations[attack_lists[team][troop].Location][troop] = "Active"
	
	#M1 moves
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			
			if TroopInfo[troop].M1 == location:
				break
			
			if TroopInfo[troop].M1 != "X":
				
				if TroopInfo[troop].FireMove == 1:
					pass
					
				else:
					
					if !TroopLocations.has(TroopInfo[troop].M1):
						TroopLocations[TroopInfo[troop].M1] = {}
						
					TroopLocations[location].remove(troop)
					TroopLocations[TroopInfo[troop].M1][troop] = "Active"
					
	#M1 attacks
	LocationBattles = {}
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			if Lo
		
