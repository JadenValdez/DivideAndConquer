extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var selected: Node2D = $Selected

var color_name: String
var button_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.modulate = button_color
	SignalBus.update_color_buttons.connect(_update_color_buttons)

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				RPCFunctions.SelectColor.rpc(multiplayer.get_unique_id(), color_name)

func _update_color_buttons() -> void:
	selected.hide()
	for id in GameManager.Players:
		if GameManager.Players[id].Name == color_name:
			selected.show()
