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
	
