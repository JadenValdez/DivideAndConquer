extends Node2D

@export var item_name: String
var item_amount: int = 0

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	SignalBus.craft_item.connect(_craft_item)
	SignalBus.use_item.connect(_use_item)
	
	label.text = item_name + "
	x" + str(item_amount) 
	color_rect.modulate = GameManager.Players[multiplayer.get_unique_id()].Color

#adds 1 to the corresponding button for the crafted item
func _craft_item(item: String) -> void:
	if item == item_name:
		item_amount += 1
		label.text = item_name + "
		x" + str(item_amount) 

#removes 1 from the corresponding button for the used item
func _use_item(item: String) -> void:
	if item == item_name:
		item_amount -= 1
		label.text = item_name + "
		x" + str(item_amount) 
		if item_amount <= 0:
			SignalBus.select_item.emit("None")

#selects the item if the player has at least 1
func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if item_amount <= 0:
					print("No " + item_name + "s remaining.")
				else:
					SignalBus.select_troop.emit(0, "Troop", "A01")
					SignalBus.select_item.emit(item_name)
