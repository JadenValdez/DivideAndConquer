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

var move_amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)
	SignalBus.plan_troop_move.connect(_plan_troop_move)
	
	color_rect.modulate = tab_color
	
	troop_id_label.text = str(troop_id)
	troop_type_tp.text = troop_type + "(" + str(troop_tp) + ")"
	troop_location.text = location
	self.position = Vector2(0, tab_number * 50)
	
	if location == "None":
		move_amount = 0
	else:
		move_amount = 1


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
		

func _plan_troop_move(id: int, action: String, location_space: String) -> void:
	if id == troop_id:
		
		if action == "Place":
			location = location_space
			troop_location.text = location
			move_amount = 1
			
		elif action == "Pause":
			match move_amount:
				1:
					move_1.show()
					m_1_location.text = "X"
					move_amount = 2
					SignalBus.select_troop.emit(troop_id, troop_type, location)
				2:
					move_2.show()
					m_2_location.text = "X"
					move_amount = 3
					SignalBus.select_troop.emit(troop_id, troop_type, location)
				3:
					move_3.show()
					m_3_location.text = "X"
					if troop_type == "TroopLeader":
						move_amount = 4
						SignalBus.select_troop.emit(troop_id, troop_type, location)
					elif troop_type == "Mortar":
						pass
						#give the mortar a 4th move if it has not fired yet
					else: 
						SignalBus.select_troop.emit(0, troop_type, location)
				4:
					move_4.show()
					m_4_location.text = "X"
					SignalBus.select_troop.emit(0, troop_type, location)
					
		elif action == "Move":
			match move_amount:
				1:
					move_1.show()
					m_1_location.text = location_space
					move_amount = 2
					SignalBus.select_troop.emit(troop_id, troop_type, location_space)
				2:
					move_2.show()
					m_2_location.text = location_space
					move_amount = 3
					SignalBus.select_troop.emit(troop_id, troop_type, location_space)
				3:
					move_3.show()
					m_3_location.text = location_space
					if troop_type == "TroopLeader":
						move_amount = 4
						SignalBus.select_troop.emit(troop_id, troop_type, location_space)
					elif troop_type == "Mortar":
						pass
						#give the mortar a 4th move if it has not fired yet
						#only firing is allowed
					else: 
						SignalBus.select_troop.emit(0, troop_type, location_space)
				4:
					move_4.show()
					m_4_location.text = location_space
					move_amount = 5
					SignalBus.select_troop.emit(0, troop_type, location_space)
			
		elif action == "Fire":
			match move_amount:
				1:
					move_1.show()
					move_1.modulate = Color(1, 0, 0, 1)
					m_1_location.text = location_space
					move_amount = 2
					SignalBus.select_troop.emit(0, troop_type, location_space)
				2:
					move_2.show()
					move_2.modulate = Color(1, 0, 0, 1)
					m_2_location.text = location_space
					move_amount = 3
					SignalBus.select_troop.emit(0, troop_type, location_space)
				1:
					move_3.show()
					move_3.modulate = Color(1, 0, 0, 1)
					m_3_location.text = location_space
					move_amount = 4
					SignalBus.select_troop.emit(0, troop_type, location_space)
				1:
					move_4.show()
					move_4.modulate = Color(1, 0, 0, 1)
					m_4_location.text = location_space
					move_amount = 5
					SignalBus.select_troop.emit(0, troop_type, location_space)
