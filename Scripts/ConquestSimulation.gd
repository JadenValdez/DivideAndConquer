extends Node

var TroopLocations: Dictionary = {}
var LocationBattles: Dictionary = {}
var TroopInfo: Dictionary = {}

var TeamTPValues: Dictionary = {}
var TeamTP: int = 0
var TeamTP2nd: int = 0
var Winners: Array = []
var WinningTeam: String = "None"

var CurrentLocation: String = "None"
var WinningTeamTroops: Array = []

var CurrentTPLoss: int = 0


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
				"M4": attack_lists[team][troop].M4,
				"Status": "Alive",
				"Location": attack_lists[team][troop].Location
			}
			
			
			if attack_lists[team][troop].Location != "None":
				
				if !TroopLocations.has(attack_lists[team][troop].Location):
					TroopLocations[attack_lists[team][troop].Location] = {}
					
				TroopLocations[attack_lists[team][troop].Location][troop] = "Active"
	
	#M1 moves
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			
			if TroopInfo[troop].M1 == location:
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
			
			if TroopInfo[troop].M1 == "X":
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
			
			if TroopInfo[troop].M1 != "X":
				
				if TroopInfo[troop].FireMove == 1:
					TroopLocations[TroopInfo[troop].M1][troop + 900] = "Active"
					TroopInfo[troop + 900] = {
						"Team": TroopInfo[troop].Team,
						"Type": "MortarShot",
						"Status": "Alive"
					}
					
				else:
					
					if !TroopLocations.has(TroopInfo[troop].M1):
						TroopLocations[TroopInfo[troop].M1] = {}
						
					TroopLocations[location].erase(troop)
					TroopLocations[TroopInfo[troop].M1][troop] = "Active"
					TroopInfo[troop].Location = TroopInfo[troop].M1
	#M1 attacks
	check_battles()
	
	#M2 moves
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			
			if TroopLocations[location][troop] == "Inactive":
				break
				
			if TroopInfo[troop].M2 == location:
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
			
			if TroopInfo[troop].M2 == "X":
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
				
			if TroopInfo[troop].M2 != "X":
				
				if TroopInfo[troop].FireMove == 2:
					TroopLocations[TroopInfo[troop].M1][troop + 900] = "Active"
					TroopInfo[troop + 900] = {
						"Team": TroopInfo[troop].Team,
						"Type": "MortarShot",
						"Status": "Alive"
					}
					
				else:
					
					if !TroopLocations.has(TroopInfo[troop].M2):
						TroopLocations[TroopInfo[troop].M2] = {}
						
					TroopLocations[location].erase(troop)
					TroopLocations[TroopInfo[troop].M2][troop] = "Active"
					TroopInfo[troop].Location = TroopInfo[troop].M2
	#M2 attacks
	check_battles()
	
	#M3 moves
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			
			if TroopLocations[location][troop] == "Inactive":
				break
				
			if TroopInfo[troop].M3 == location:
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
			
			if TroopInfo[troop].M3 == "X":
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
				
			if TroopInfo[troop].M3 != "X":
				
				if TroopInfo[troop].FireMove == 3:
					TroopLocations[TroopInfo[troop].M1][troop + 900] = "Active"
					TroopInfo[troop + 900] = {
						"Team": TroopInfo[troop].Team,
						"Type": "MortarShot",
						"Status": "Alive"
					}
					
				else:
					
					if !TroopLocations.has(TroopInfo[troop].M3):
						TroopLocations[TroopInfo[troop].M3] = {}
						
					TroopLocations[location].erase(troop)
					TroopLocations[TroopInfo[troop].M3][troop] = "Active"
					TroopInfo[troop].Location = TroopInfo[troop].M3
	#M3 attacks
	check_battles()
	
	#M4 moves
	for location in TroopLocations.keys():
		for troop in TroopLocations[location].keys():
			
			if TroopLocations[location][troop] == "Inactive":
				break
				
			if TroopInfo[troop].M4 == location:
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
			
			if TroopInfo[troop].M4 == "X":
				TroopLocations[location][troop] = "Idle"
				TroopInfo[troop].Location = location
				break
				
			if TroopInfo[troop].M4 != "X":
				
				if TroopInfo[troop].FireMove == 4:
					TroopLocations[TroopInfo[troop].M4][troop + 900] = "Active"
					TroopInfo[troop + 900] = {
						"Team": TroopInfo[troop].Team,
						"Type": "MortarShot",
						"Status": "Alive"
					}
					
				else:
					
					if !TroopLocations.has(TroopInfo[troop].M4):
						TroopLocations[TroopInfo[troop].M4] = {}
						
					TroopLocations[location].erase(troop)
					TroopLocations[TroopInfo[troop].M4][troop] = "Active"
					TroopInfo[troop].Location = TroopInfo[troop].M4
	#M4 attacks
	check_battles()
	
	RPCFunctions.UpdateTroopInfo.rpc(TroopInfo.duplicate(true))

func check_battles() -> void:
	LocationBattles = {}
	for location in TroopLocations.keys():
		CurrentLocation = location
		LocationBattles[CurrentLocation] = []
			
		for troop in TroopLocations[CurrentLocation]:
			if !LocationBattles[CurrentLocation].has(TroopInfo[troop].Team):
				LocationBattles[CurrentLocation].append(TroopInfo[troop].Team)
				
				
		if LocationBattles[CurrentLocation].size() == 0:
			print("where is everyone")
			
		elif LocationBattles[CurrentLocation].size() == 1:
			
			if LocationInfo.Tiles[CurrentLocation] == "None":
				default_win(LocationBattles[CurrentLocation][0])
				
			elif LocationInfo.Tiles[CurrentLocation] == LocationBattles[CurrentLocation][0]:
				pass
				#nothing happens
				
			else:
				
				WinningTeam = determine_battle_winner(
					{TroopLocations[CurrentLocation][0]: calculate_team_tp(TroopLocations[location][0]),
				LocationBattles[CurrentLocation].keys()[0]: 1}
				)
				
				if WinningTeam == "None":
					LocationInfo.Tiles[CurrentLocation] = "None"
				elif WinningTeam != LocationInfo.Tiles[CurrentLocation]:
					LocationInfo.Tiles[CurrentLocation] = WinningTeam
					for troop in TroopLocations[CurrentLocation]:
						if TroopLocations[CurrentLocation][troop] != "Dead":
							TroopLocations[CurrentLocation][troop] = "Inactive"
				else:
					LocationInfo.Tiles[CurrentLocation] = WinningTeam
					
				
		else:
			TeamTPValues = {}
			for team in LocationBattles[CurrentLocation]:
				TeamTPValues[team] = calculate_team_tp(team)
			WinningTeam = determine_battle_winner(TeamTPValues)
			if WinningTeam == "None":
				LocationInfo.Tiles[CurrentLocation] = "None"
			elif WinningTeam != LocationInfo.Tiles[CurrentLocation]:
				LocationInfo.Tiles[CurrentLocation] = WinningTeam
				for troop in TroopLocations[CurrentLocation]:
					TroopLocations[CurrentLocation][troop] = "Inactive"
		
		for troop in TroopLocations[CurrentLocation]:
			if TroopInfo[troop].Type == "MortarShot":
				TroopLocations[CurrentLocation].erase(troop)
		
	for troop in TroopInfo.keys():
		if TroopInfo[troop].Type == "MortarShot":
			TroopInfo.erase(troop)

func default_win(winning_team: String) -> void:
	for troop in TroopLocations[CurrentLocation]:
		TroopLocations[CurrentLocation][troop] = "Inactive"
	LocationInfo.Tiles[CurrentLocation] = winning_team
	
func calculate_team_tp(team: String) -> int:
	TeamTP = 0
	for troop in TroopLocations[CurrentLocation]:
		if TroopInfo[troop].Team == team:
			TeamTP += TroopInfo[troop].TP
			
	if LocationInfo.Tiles[CurrentLocation] == team:
		return (TeamTP + 1)
	return TeamTP
	
func determine_battle_winner(tp_values: Dictionary) -> String:
	TeamTP = 0
	TeamTP2nd = 0
	for team in tp_values:
		if tp_values[team] > TeamTP:
			TeamTP2nd = TeamTP
			TeamTP = tp_values[team]
		elif tp_values[team] > TeamTP2nd:
			TeamTP2nd = tp_values[team]
	
	Winners = []
	for team in tp_values:
		if tp_values[team] < TeamTP:
			battle_loss(team)
		else:
			Winners.append(team)
	
	if Winners.size() >= 2:
		for team in Winners:
			battle_loss(team)
		return("None")
	elif Winners.size() == 1:
		calculate_troop_losses(Winners[0], TeamTP2nd)
		return(Winners[0])
	else:
		print("idk")
		return("None")
	
func calculate_troop_losses(winning_team: String, tp_loss: int) -> void:
	WinningTeamTroops = []
	CurrentTPLoss = tp_loss
	for troop in TroopLocations[CurrentLocation]:
		if TroopInfo[troop].Team == winning_team:
			WinningTeamTroops.append(troop)
			
			
	#mortar shot (not coded yet)
	#tank
	#troop
	#actual mortar
	#troop leader
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "MortarShot":
			if CurrentTPLoss >= 5:
				CurrentTPLoss -= 5
				TroopLocations[CurrentLocation].erase(troop)
				TroopInfo[troop].Status = "Dead"
				if CurrentTPLoss == 0:
					return
			else:
				return
	
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "Tank":
			if CurrentTPLoss >= TroopInfo[troop].TP:
				CurrentTPLoss -= TroopInfo[troop].TP
				TroopLocations[CurrentLocation].erase(troop)
				TroopInfo[troop].Status = "Dead"
				if CurrentTPLoss == 0:
					return
			else:
				TroopInfo[troop].TP -= CurrentTPLoss
				if TroopInfo[troop].TP == 0:
					TroopLocations[CurrentLocation].erase(troop)
					TroopInfo[troop].Status = "Dead"
				return
				
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "Troop":
			if CurrentTPLoss >= TroopInfo[troop].TP:
				CurrentTPLoss -= TroopInfo[troop].TP
				TroopLocations[CurrentLocation].erase(troop)
				TroopInfo[troop].Status = "Dead"
				if CurrentTPLoss == 0:
					return
			else:
				TroopInfo[troop].TP -= CurrentTPLoss
				if TroopInfo[troop].TP == 0:
					TroopLocations[CurrentLocation].erase(troop)
					TroopInfo[troop].Status = "Dead"
				return
				
	#mortars instantly die
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "Mortar":
			TroopLocations[CurrentLocation].erase(troop)
			TroopInfo[troop].Status = "Dead"
	
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "TroopLeader":
			if CurrentTPLoss >= TroopInfo[troop].TP:
				CurrentTPLoss -= TroopInfo[troop].TP
				TroopLocations[CurrentLocation].erase(troop)
				TroopInfo[troop].Status = "Dead"
				if CurrentTPLoss == 0:
					return
			else:
				TroopInfo[troop].TP -= CurrentTPLoss
				if TroopInfo[troop].TP == 0:
					TroopLocations[CurrentLocation].erase(troop)
					TroopInfo[troop].Status = "Dead"
				return
				
func battle_loss(team: String) -> void:
	for troop in TroopLocations[CurrentLocation].keys():
		if TroopInfo[troop].Team == team:
			TroopLocations[CurrentLocation].erase(troop)
			TroopInfo[troop].Status = "Dead"
			#signal for defeating troop
			pass
