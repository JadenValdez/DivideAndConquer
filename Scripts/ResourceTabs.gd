extends Node2D

@onready var food_label: Label = $Food/FoodLabel
@onready var gp_label: Label = $GP/GPLabel
@onready var ap_label: Label = $AP/APLabel
@onready var sp_label: Label = $SP/SPLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_resources.connect(_add_resources)
	SignalBus.update_resource_tabs.connect(_update_resource_tabs)
	_update_resource_tabs()

#updates the resource labels
func _update_resource_tabs() -> void:
	food_label.text = "Food: " + str(GameManager.Players[multiplayer.get_unique_id()].Resources.Food)
	gp_label.text = "GP: " + str(GameManager.Players[multiplayer.get_unique_id()].Resources.GP)
	ap_label.text = "AP: " + str(GameManager.Players[multiplayer.get_unique_id()].Resources.AP)
	sp_label.text = "SP: " + str(GameManager.Players[multiplayer.get_unique_id()].Resources.SP)

#adds resources depending on the tiles that the player owns
func _add_resources(tile_type: String) -> void:
	for resource_type in TileResources.RESOURCES[tile_type]:
		GameManager.Players[multiplayer.get_unique_id()].Resources[resource_type] += TileResources.RESOURCES[tile_type][resource_type]
	_update_resource_tabs()
