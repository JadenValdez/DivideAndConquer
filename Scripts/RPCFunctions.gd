extends Node

@rpc("call_local", "any_peer")
func SelectColor(id: int, color_name: String) -> void:
	SignalBus.select_color.emit(id, color_name)

@rpc("call_local", "any_peer")
func StartGame() -> void:
	SignalBus.start_game.emit()
