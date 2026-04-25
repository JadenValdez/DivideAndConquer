extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var troop_id_label: Label = $TroopID
@onready var troop_type_tp: Label = $TroopTypeTP
@onready var troop_location: Label = $TroopLocation

@onready var move_1: Node2D = $Move1
@onready var m_1_location: Label = $Move1/M1Location
@onready var move_2: Node2D = $Move2
@onready var m_2_location: Label = $Move2/M2Location
@onready var move_3: Node2D = $Move3
@onready var m_3_location: Label = $Move3/M3Location
@onready var move_4: Node2D = $Move4
@onready var m_4_location: Label = $Move4/M4Location

var troop_id: int
var troop_type: String
var troop_tp: int
var location: String

var tab_number: int 
var tab_color: Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)
	
	color_rect.modulate = tab_color
	
	troop_id_label.text = str(troop_id)
	troop_type_tp.text = troop_type + "(" + str(troop_tp) + ")"
	troop_location.text = location
	self.position = Vector2(0, tab_number * 50)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.select_troop.emit(troop_id, troop_type, location)

func _select_troop(id: int, _type: String, _troop_location: String) -> void:
	if id == troop_id:
		self.position = Vector2(20, tab_number * 50)
	else:
		self.position = Vector2(0, tab_number * 50)
		
