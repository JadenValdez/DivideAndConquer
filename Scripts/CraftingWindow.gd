extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_craft_troop_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 1:
		GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 1
		SignalBus.craft_troop.emit("Troop", 1)
		SignalBus.update_resource_tabs.emit()
	else:
		print("Cannot afford Troop")

func _on_craft_tank_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 2:
		GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 2
		SignalBus.craft_troop.emit("Tank", 5)
		SignalBus.update_resource_tabs.emit()
	else:
		print("Cannot afford Tank")

func _on_craft_mortar_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 2:
		GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 1
		SignalBus.craft_troop.emit("Mortar", 0)
		SignalBus.update_resource_tabs.emit()
	else:
		print("Cannot afford Mortar")


func _on_craft_wall_pressed() -> void:
	pass

func _on_craft_medkit_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.SP >= 2:
		if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 8 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 3 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 2:
			GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 8
			GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 3
			GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 2
			SignalBus.craft_item.emit("Medkit")
			SignalBus.update_resource_tabs.emit()
		else:
			print("Cannot afford Medkit")
	else:
		print("Not Enough SP")


func _on_craft_upgraded_troop_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.SP >= 3:
		if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 2:
			GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 1
			GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 2
			SignalBus.craft_item.emit("Upgraded Troop")
			SignalBus.update_resource_tabs.emit()
		else:
			print("Cannot afford Upgraded Troop")
	else:
		print("Not Enough SP")


func _on_craft_jet_plane_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.SP >= 5:
		if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 2 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 10 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 6:
			GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 2
			GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 10
			GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 6
			SignalBus.craft_item.emit("Jet Plane")
			SignalBus.update_resource_tabs.emit()
		else:
			print("Cannot afford Jet Plane")
	else:
		print("Not Enough SP")


func _on_craft_bomber_plane_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.SP >= 15:
		if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 2 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 16 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 8:
			GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 2
			GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 16
			GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 8
			SignalBus.craft_item.emit("Bomber Plane")
			SignalBus.update_resource_tabs.emit()
		else:
			print("Cannot afford Bomber Plane")
	else:
		print("Not Enough SP")


func _on_craft_missile_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.SP >= 10:
		if GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 20 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 15:
			GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 20
			GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 15
			SignalBus.craft_item.emit("Missile")
			SignalBus.update_resource_tabs.emit()
		else:
			print("Cannot afford Missile")
	else:
		print("Not Enough SP")
