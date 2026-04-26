extends Node2D

@onready var food_label: Label = $Food/FoodLabel
@onready var gp_label: Label = $GP/GPLabel
@onready var ap_label: Label = $AP/APLabel
@onready var sp_label: Label = $SP/SPLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_resource_tabs()

func update_resource_tabs() -> void:
	food_label.text = str(GameManager.Players[multiplayer.get_unique_id()].Resources.Food)
	gp_label.text = str(GameManager.Players[multiplayer.get_unique_id()].Resources.GP)
	ap_label.text = str(GameManager.Players[multiplayer.get_unique_id()].Resources.AP)
	sp_label.text = str(GameManager.Players[multiplayer.get_unique_id()].Resources.SP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
