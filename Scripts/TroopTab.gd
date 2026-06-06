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

@onready var item_button: Node2D = $ItemButton

var troop_id: int
var troop_type: String
var troop_tp: int
var location: String

var tab_number: int 
var tab_color: Color

var move_amount: int
var fire_move: String = "M0"

var uses: int

var recently_crafted: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.select_troop.connect(_select_troop)
	SignalBus.plan_troop_move.connect(_plan_troop_move)
	SignalBus.undo_move.connect(_undo_move)
	SignalBus.get_attack_lists.connect(_get_attack_lists)
	
	SignalBus.troop_defeated.connect(_troop_defeated)
	SignalBus.move_troop_tabs.connect(_move_troop_tabs)
	SignalBus.update_troop_info.connect(_update_troop_info)
	
	SignalBus.show_troop_item_buttons.connect(_show_troop_item_buttons)
	SignalBus.select_item.connect(_select_item)
	
	color_rect.modulate = tab_color
	
	troop_id_label.text = str(troop_id)
	troop_type_tp.text = troop_type + "(" + str(troop_tp) + ")"
	troop_location.text = location
	self.position = Vector2(0, tab_number * 50)
	
	if location == "None":
		move_amount = 0
	else:
		move_amount = 1

#selects the troop when its troop tab is clicked
func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.select_item.emit("None")
				SignalBus.select_troop.emit(troop_id, troop_type, location)

#moves the selected troop tab over slightly to show it is currently selected
func _select_troop(id: int, _type: String, _troop_location: String) -> void:
	if id == troop_id:
		self.position = Vector2(20, tab_number * 50)
	else:
		self.position = Vector2(0, tab_number * 50)
		

#saves the chosen tile as part of this troop's move list depending on the current action
func _plan_troop_move(id: int, action: String, location_space: String) -> void:
	if id == troop_id:
		
		#if placing the troop, set the troop's location to the chosen tile
		if action == "Place":
			location = location_space
			troop_location.text = location
			move_amount = 1
			SignalBus.select_troop.emit(troop_id, troop_type, location_space)
			
		#if not moving the troop, adds a "pause" move to the move list
		elif action == "Pause":
			match move_amount:
				1:
					move_1.show()
					m_1_location.text = "X"
					move_amount = 2
					SignalBus.select_troop.emit(troop_id, troop_type, location_space)
				2:
					move_2.show()
					m_2_location.text = "X"
					move_amount = 3
					SignalBus.select_troop.emit(troop_id, troop_type, location_space)
				3:
					move_3.show()
					m_3_location.text = "X"
					if troop_type == "TroopLeader":
						move_amount = 4
						SignalBus.select_troop.emit(troop_id, troop_type, location_space)
					elif troop_type == "Mortar":
						if fire_move == "M0":
							move_amount = 4
							SignalBus.select_troop.emit(troop_id, "MortarFire", location_space)
						else:
							SignalBus.select_troop.emit(0, troop_type, location_space)
					else: 
						SignalBus.select_troop.emit(0, troop_type, location_space)
				4:
					move_4.show()
					m_4_location.text = "X"
					SignalBus.select_troop.emit(0, troop_type, location_space)
					
		#if moving the troop to a new tile, save that tile as the action for the current move
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
						if fire_move == "M0":
							move_amount = 4
							SignalBus.select_troop.emit(troop_id, "MortarFire", location_space)
						else:
							SignalBus.select_troop.emit(0, troop_type, location_space)
					else: 
						SignalBus.select_troop.emit(0, troop_type, location_space)
				4:
					move_4.show()
					m_4_location.text = location_space
					move_amount = 5
					SignalBus.select_troop.emit(0, troop_type, location)
		
		#if firing at a tile, save that tile as the fire action for the current move
		elif action == "Fire":
			match move_amount:
				1:
					move_1.show()
					move_1.modulate = Color(1, 0, 0, 1)
					m_1_location.text = location
					fire_move = "M1"
					move_amount = 2
					SignalBus.select_troop.emit(0, troop_type, location_space)
				2:
					move_2.show()
					move_2.modulate = Color(1, 0, 0, 1)
					m_2_location.text = location
					fire_move = "M2"
					move_amount = 3
					SignalBus.select_troop.emit(0, troop_type, location_space)
				3:
					move_3.show()
					move_3.modulate = Color(1, 0, 0, 1)
					m_3_location.text = location
					fire_move = "M3"
					move_amount = 4
					SignalBus.select_troop.emit(0, troop_type, location_space)
				4:
					move_4.show()
					move_4.modulate = Color(1, 0, 0, 1)
					m_4_location.text = location
					fire_move = "M4"
					move_amount = 5
					SignalBus.select_troop.emit(0, troop_type, location_space)

#undo the most recent move for the current troop
func _undo_move() -> void:
	if troop_id == PlayerInformation.SelectedTroop:
		match move_amount:
			
			#no moves to undo
			0: 
				location = "None"
				troop_location.text = "None"
				SignalBus.select_troop.emit(0, troop_type, "None")
				
			#if the troop was just crafted, undo the place action
			#otherwise, nothing happens
			1:
				if recently_crafted:
					location = "None"
					troop_location.text = "None"
					move_amount = 0
					SignalBus.select_troop.emit(troop_id, troop_type, "None")
					
				else:
					SignalBus.select_troop.emit(0, troop_type, "None")
			
			#undo move 1 and move the troop to the previous location
			2:
				move_1.hide()
				move_1.modulate = Color(1, 1, 1, 1)
				m_1_location.text = "X"
				if fire_move == "M1":
					fire_move = "M0"
				move_amount = 1
				if recently_crafted:
					SignalBus.select_troop.emit(troop_id, troop_type, "None")
				else:
					SignalBus.select_troop.emit(troop_id, troop_type, location)
			
			#undo move 2 and move the troop to the previous location
			3:
				move_2.hide()
				move_2.modulate = Color(1, 1, 1, 1)
				m_2_location.text = "X"
				if fire_move == "M2":
					fire_move = "M0"
				move_amount = 2
				if m_1_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_1_location.text)
				elif recently_crafted:
					SignalBus.select_troop.emit(troop_id, troop_type, "None")
				else:
					SignalBus.select_troop.emit(troop_id, troop_type, location)
					
			#undo move 3 and move the troop to the previous location
			4:
				move_3.hide()
				move_3.modulate = Color(1, 1, 1, 1)
				m_3_location.text = "X"
				if fire_move == "M3":
					fire_move = "M0"
				move_amount = 3
				if m_2_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_2_location.text)
				elif m_1_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_1_location.text)
				elif recently_crafted:
					SignalBus.select_troop.emit(troop_id, troop_type, "None")
				else:
					SignalBus.select_troop.emit(troop_id, troop_type, location)
			
			#undo move 4 and move the troop to the previous location
			5: 
				move_4.hide()
				move_4.modulate = Color(0, 0, 0, 1)
				m_4_location.text = "X"
				if fire_move == "M4":
					fire_move = "M0"
				move_amount = 4
				if m_3_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_3_location.text)
				elif m_2_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_2_location.text)
				elif m_1_location.text != "X":
					SignalBus.select_troop.emit(troop_id, troop_type, m_1_location.text)
				elif recently_crafted:
					SignalBus.select_troop.emit(troop_id, troop_type, "None")
				else:
					SignalBus.select_troop.emit(troop_id, troop_type, location)
	
#sends the move list of the troop to the server, then resets all related variables
func _get_attack_lists() -> void:
	PlayerInformation.AttackList[troop_id] = {
		"Team": GameManager.Players[multiplayer.get_unique_id()].Name,
		"Type": troop_type,
		"TP": troop_tp,
		"Location": location, 
		"FireMove": fire_move,
		"M1": m_1_location.text, 
		"M2": m_2_location.text, 
		"M3": m_3_location.text, 
		"M4": m_4_location.text
		}
		
	move_1.hide()
	move_2.hide()
	move_3.hide()
	move_4.hide()
	move_1.modulate = Color(1, 1, 1, 1)
	move_2.modulate = Color(1, 1, 1, 1)
	move_3.modulate = Color(1, 1, 1, 1)
	move_4.modulate = Color(1, 1, 1, 1)
	m_1_location.text = "X"
	m_2_location.text = "X"
	m_3_location.text = "X"
	m_4_location.text = "X"
	
	if recently_crafted && location == "None":
		move_amount = 0
	else:
		move_amount = 1
		recently_crafted = false
	
	fire_move = "M0"
	SignalBus.check_if_attacks_ready.emit()

#removes the troop tab if the corresponding troop is defeated in conquest
func _troop_defeated(troop: int) -> void:
	if troop == troop_id:
		SignalBus.move_troop_tabs.emit(tab_number)
		queue_free()
		
#moves the lower troop tabs into position when a troop is defeated
func _move_troop_tabs(defeated_tab_number: int) -> void:
	if defeated_tab_number < tab_number:
		tab_number -= 1
		self.position = Vector2(0, tab_number * 50)
		
#updates the current status of the troop
func _update_troop_info(troop: int, tp: int, location_troop: String) -> void:
	if troop == troop_id:
		troop_tp = tp
		troop_type_tp.text = troop_type + "(" + str(troop_tp) + ")"
		
		location = location_troop
		troop_location.text = location

#show the item button if the troop is considered a valid target for the selected item
func _show_troop_item_buttons(item_name: String) -> void:
	item_button.hide()
	match item_name:
		"Medkit":
			if troop_tp <= UnitsInformation.Units[troop_type].TP:
				item_button.show()
		"Upgraded Troop":
			if troop_type == "Troop":
				item_button.show()

#use the current item on the selected troop
func _on_ib_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				match ItemLogic.CurrentItem:
					"None":
						pass
					"Medkit":
						troop_tp += ceil(UnitsInformation.Units[troop_type].TP / 2)
						if troop_tp > UnitsInformation.Units[troop_type].TP:
							troop_tp = UnitsInformation.Units[troop_type].TP
						SignalBus.use_item.emit("Medkit")
					"Upgraded Troop":
						troop_type = "Upgraded Troop"
						troop_tp += 1
						SignalBus.use_item.emit("Upgraded Troop")
						
#hides the item button when a new item is initially selected
func _select_item(item_name: String) -> void:
	if item_name == "None":
		item_button.hide()
