extends Node

#selects a color for a player
@rpc("call_local", "any_peer")
func SelectColor(id: int, color_name: String) -> void:
	SignalBus.select_color.emit(id, color_name)

#shows which colors have been taken
@rpc("call_local", "any_peer")
func UpdateColorButtons() -> void:
	SignalBus.update_color_buttons.emit()
	
#shows how many players are ready
@rpc("call_local", "any_peer")
func UpdateReadyPlayersLobby() -> void:
	SignalBus.update_ready_players_lobby.emit()

#starts the game
@rpc("call_local", "any_peer")
func StartGame() -> void:
	SignalBus.start_game.emit()
	
#increases the amount of ready players
@rpc("call_local", "any_peer")
func ReadyPlayer() -> void:
	GameManager.ReadyPlayers += 1
	SignalBus.update_ready_players_board.emit()
	if GameManager.ReadyPlayers >= GameManager.TotalPlayers:
		GameManager.ReadyPlayers = 0
		SignalBus.get_attack_lists.emit()
		#start battle sequence
	
#decreases the amount of ready players
@rpc("call_local", "any_peer")
func NotReadyPlayer() -> void:
	GameManager.ReadyPlayers -= 1
	SignalBus.update_ready_players_board.emit()

#compilies all attack lists to the server
@rpc("call_local", "any_peer")
func SendAttackList(team: String, attack_list: Dictionary) -> void:
	if multiplayer.is_server():
		GameManager.AttackLists[team] = attack_list
		for player_id in GameManager.Players:
			if !GameManager.AttackLists.has(GameManager.Players[player_id].Name):
				return
		print(GameManager.AttackLists)
		ConquestSimulation.SimulateConquest(GameManager.AttackLists.duplicate(true))
		GameManager.AttackLists = {}

#updates the troop statuses for all players
@rpc("call_local", "any_peer")
func UpdateTroopInfo(troop_info: Dictionary) -> void:
	for troop in troop_info:
		if troop_info[troop].Team == GameManager.Players[multiplayer.get_unique_id()].Name:
			if troop_info[troop].Status == "Dead":
				SignalBus.troop_defeated.emit(troop)
			else:
				SignalBus.update_troop_info.emit(troop, troop_info[troop].TP, troop_info[troop].Location)
	if multiplayer.is_server():
		UpdateTerritoryColors.rpc(LocationInfo.Tiles.duplicate(true))

#updates the colors of the tiles on the board
@rpc("call_local", "any_peer")
func UpdateTerritoryColors(location_info: Dictionary) -> void:
	LocationInfo.Tiles = location_info
	for id in GameManager.Players:
		GameManager.Players[id].Territory = []
		for tile_name in LocationInfo.Tiles:
			if LocationInfo.Tiles[tile_name] == GameManager.Players[id].Name:
				GameManager.Players[id].Territory.append(tile_name)
	SignalBus.update_territory_colors.emit()
	SignalBus.get_round_resources.emit()
	SignalBus.start_next_round.emit()
	
	GameManager.ReadyPlayers = 0
	SignalBus.update_ready_players_board.emit()
