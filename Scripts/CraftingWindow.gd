extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_craft_troop_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 1:
		GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 1
		#craft
	else:
		print("Cannot afford Troop")

func _on_craft_tank_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.Food >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 2:
		GameManager.Players[multiplayer.get_unique_id()].Resources.Food -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 2
	else:
		print("Cannot afford Tank")

func _on_craft_mortar_pressed() -> void:
	if GameManager.Players[multiplayer.get_unique_id()].Resources.GP >= 1 && GameManager.Players[multiplayer.get_unique_id()].Resources.AP >= 2:
		GameManager.Players[multiplayer.get_unique_id()].Resources.GP -= 1
		GameManager.Players[multiplayer.get_unique_id()].Resources.AP -= 1
	else:
		print("Cannot afford Mortar")


func _on_craft_wall_pressed() -> void:
	pass # Replace with function body.
