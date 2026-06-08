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

#simulates the conquest hase using each player's attack list
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
	
	print("M0")
	print(TroopLocations)
	
	#puts each troop into their positions each move
	for move in ["M1", "M2", "M3", "M4"]:
		
		for location in TroopLocations.keys():
			for troop in TroopLocations[location].keys():
				print(troop)
				
				if TroopInfo[troop].Type == "Jet Plane" || TroopInfo[troop].Type == "Bomber Plane" || TroopInfo[troop].Type == "Missile":
					if TroopInfo[troop][move] == location || TroopInfo[troop][move] == "X":
						TroopLocations[location][troop] = "Idle"
						TroopInfo[troop].Location = location
						print("same location")
					else:
						if !TroopLocations.has(TroopInfo[troop][move]):
							TroopLocations[TroopInfo[troop][move]] = {}
							
						TroopLocations[location].erase(troop)
						TroopLocations[TroopInfo[troop][move]][troop] = "Active"
						TroopInfo[troop].Location = TroopInfo[troop][move]
				
				#if a troop has been part of a previous territory capture, they are inactive
				if TroopLocations[location][troop] == "Inactive":
					print("inactive")
					
				#if a troop stays at their location, they are idle
				elif TroopInfo[troop][move] == "X":
					TroopLocations[location][troop] = "Idle"
					TroopInfo[troop].Location = location
					print("x location")
					
				elif TroopInfo[troop][move] == location:
					
					TroopLocations[location][troop] = "Idle"
					TroopInfo[troop].Location = location
					print("same location")
					
				#if a troop is active and does not stay at their location, move them
				elif TroopInfo[troop][move] != "X":
					
					#if the troop is a mortar and shot this move, create a new MortarShot troop for this move
					if TroopInfo[troop].FireMove == move:
						TroopLocations[TroopInfo[troop][move]][troop + 900] = "Active"
						TroopInfo[troop + 900] = {
							"Team": TroopInfo[troop].Team,
							"Type": "MortarShot",
							"Status": "Alive"
						}
						
					#move the troop
					else:
						if !TroopLocations.has(TroopInfo[troop][move]):
							TroopLocations[TroopInfo[troop][move]] = {}
							
						TroopLocations[location].erase(troop)
						TroopLocations[TroopInfo[troop][move]][troop] = "Active"
						TroopInfo[troop].Location = TroopInfo[troop][move]
		print(move)
		print(TroopLocations)
		#check the battles at each location
		check_battles()
		
	#update the status of troops for all players
	RPCFunctions.UpdateTroopInfo.rpc(TroopInfo.duplicate(true))

#check the battles at each location
func check_battles() -> void:
	LocationBattles = {}
	for location in TroopLocations.keys():
		CurrentLocation = location
		LocationBattles[CurrentLocation] = []
			
		for troop in TroopLocations[CurrentLocation]:
			if !LocationBattles[CurrentLocation].has(TroopInfo[troop].Team):
				LocationBattles[CurrentLocation].append(TroopInfo[troop].Team)
				
		#this should only happen if all troops of a team move off a tile
		if LocationBattles[CurrentLocation].size() == 0:
			print("where is everyone")
			
		#if there is only one team, check who owns the tile they are on
		elif LocationBattles[CurrentLocation].size() == 1:
			
			#if the tile is not owned by anyone, they win by default
			if LocationInfo.Tiles[CurrentLocation] == "None":
				default_win(LocationBattles[CurrentLocation][0])
				
			#if the tile is owned by the team, nothing happens
			elif LocationInfo.Tiles[CurrentLocation] == LocationBattles[CurrentLocation][0]:
				pass
				
			#if the tile is owned by an opposing team, set the opposing team power to 1
			else:
				WinningTeam = determine_battle_winner(
					{TroopLocations[CurrentLocation][0]: calculate_team_tp(TroopLocations[location][0]),
				LocationBattles[CurrentLocation].keys()[0]: 1}
				)
				
				#if both sides have the same team power, the tile becomes neutral
				if WinningTeam == "None":
					LocationInfo.Tiles[CurrentLocation] = "None"
					
				#if the attacking team wins, the tile is owned by the attackers and the troops become inactive
				elif WinningTeam != LocationInfo.Tiles[CurrentLocation]:
					LocationInfo.Tiles[CurrentLocation] = WinningTeam
					for troop in TroopLocations[CurrentLocation]:
						if TroopLocations[CurrentLocation][troop] != "Dead":
							TroopLocations[CurrentLocation][troop] = "Inactive"
							
				#if the defending team wins for some reason (shouldn't really happen)
				else:
					LocationInfo.Tiles[CurrentLocation] = WinningTeam
					
				
		#if there is more than one team on a tile, simulate a battle between all of them
		else:
			TeamTPValues = {}
			for team in LocationBattles[CurrentLocation]:
				TeamTPValues[team] = calculate_team_tp(team)
			WinningTeam = determine_battle_winner(TeamTPValues)
			
			#if there is a tie, the tile becomes neutral
			if WinningTeam == "None":
				LocationInfo.Tiles[CurrentLocation] = "None"
				
			#if the winning team did not originally own the tile, then all of their troops on that tile become inactive
			elif WinningTeam != LocationInfo.Tiles[CurrentLocation]:
				LocationInfo.Tiles[CurrentLocation] = WinningTeam
				for troop in TroopLocations[CurrentLocation]:
					TroopLocations[CurrentLocation][troop] = "Inactive"
					
			#if the winning team originally owned the tile, nothing happens
			elif WinningTeam == LocationInfo.Tiles[CurrentLocation]:
				pass
		
		for troop in TroopLocations[CurrentLocation]:
			if TroopInfo[troop].Type == "MortarShot":
				TroopLocations[CurrentLocation].erase(troop)
		
	for troop in TroopInfo.keys():
		if TroopInfo[troop].Type == "MortarShot":
			TroopInfo.erase(troop)

#if a troop goes onto a neutral tile, they automatically claim it and become inactive
func default_win(winning_team: String) -> void:
	for troop in TroopLocations[CurrentLocation]:
		TroopLocations[CurrentLocation][troop] = "Inactive"
	LocationInfo.Tiles[CurrentLocation] = winning_team
	
#calculate the tp of each team based on their troops on that tile
func calculate_team_tp(team: String) -> int:
	TeamTP = 0
	for troop in TroopLocations[CurrentLocation]:
		if TroopInfo[troop].Team == team:
			TeamTP += TroopInfo[troop].TP
			
	if LocationInfo.Tiles[CurrentLocation] == team:
		return (TeamTP + 1)
	return TeamTP
	
#compares all team powers, then gives the win to the team with the most TP
#if there is a tie for most TP, then all teams lose and the tile becomes neutral
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
	
#deals the amount of TP of the 2nd-highest team to the winning team
#will deal TP damage in order from most Max TP to least, with the exception of Mortar Shot (first) and Troop Leader (last)
func calculate_troop_losses(winning_team: String, tp_loss: int) -> void:
	WinningTeamTroops = []
	CurrentTPLoss = tp_loss
	for troop in TroopLocations[CurrentLocation]:
		if TroopInfo[troop].Team == winning_team:
			WinningTeamTroops.append(troop)
			
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "Bomber Plane":
			if CurrentTPLoss >= 4:
				CurrentTPLoss -= 4
				if CurrentTPLoss == 0:
					return
			else:
				return
				
	for troop in WinningTeamTroops:
		if TroopInfo[troop].Type == "Jet Plane":
			if CurrentTPLoss >= 4:
				CurrentTPLoss -= 4
				if CurrentTPLoss == 0:
					return
			else:
				return
			
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
		if TroopInfo[troop].Type == "Upgraded Troop":
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
				
#if a team loses a battle, all their troops on that tile are defeated
func battle_loss(team: String) -> void:
	for troop in TroopLocations[CurrentLocation].keys():
		if TroopInfo[troop].Team == team:
			if TroopInfo[troop].Type == "Jet Plane" || TroopInfo[troop].Type == "Bomber Plane" || TroopInfo[troop].Type == "Missile":
				pass
			else:
				TroopLocations[CurrentLocation].erase(troop)
				TroopInfo[troop].Status = "Dead"
				#signal for defeating troop
				pass
