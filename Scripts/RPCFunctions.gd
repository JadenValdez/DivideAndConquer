extends Node

@rpc("call_local", "any_peer")
func SelectColor(id: int, color_name: String) -> void:
	SignalBus.select_color.emit(id, color_name)

@rpc("call_local", "any_peer")
func UpdateColorButtons() -> void:
	SignalBus.update_color_buttons.emit()
	
@rpc("call_local", "any_peer")
func UpdateReadyPlayersLobby() -> void:
	SignalBus.update_ready_players_lobby.emit()

@rpc("call_local", "any_peer")
func StartGame() -> void:
	SignalBus.start_game.emit()
	
@rpc("call_local", "any_peer")
func ReadyPlayer() -> void:
	GameManager.ReadyPlayers += 1
	SignalBus.update_ready_players_board.emit()
	if GameManager.ReadyPlayers >= GameManager.TotalPlayers:
		GameManager.ReadyPlayers = 0
		SignalBus.get_attack_lists.emit()
		#start battle sequence
	
@rpc("call_local", "any_peer")
func NotReadyPlayer() -> void:
	GameManager.ReadyPlayers -= 1

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
