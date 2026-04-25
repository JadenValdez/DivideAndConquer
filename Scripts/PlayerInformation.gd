extends Node

var SelectedTroop: int


func _ready() -> void:
	SignalBus.select_troop.connect(SelectTroop)

func SelectTroop(id: int, _type: String, _troop_location: String) -> void:
	SelectedTroop = id
