extends Control
var address_res: String = "C:\\Users\\Jaden\\Documents\\addressgodot.txt"
var address_file = FileAccess.open(address_res, FileAccess.READ)
var Address: String
var port_res: String = "C:\\Users\\Jaden\\Documents\\portgodot.txt"
var port_file = FileAccess.open(port_res, FileAccess.READ)
var port: int 
var peer

@onready var pre_game: Node2D = $PreGame
@onready var lobby: Node2D = $Lobby


func _ready() -> void:
	SignalBus.start_game.connect(_start_game)
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		_host_game()
	if FileAccess.file_exists(address_res):
		Address = address_file.get_as_text()
	if FileAccess.file_exists(port_res):
		port = int(port_file.get_as_text())
		
	

func peer_connected(id: int):
	print("Player Connected " + str(id))
	
func peer_disconnected(id: int):
	print("Player Disconnected " + str(id))
	GameManager.TotalPlayers -= 1
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
func connected_to_server():
	print("connected To Sever!")
	_set_new_player.rpc_id(1, multiplayer.get_unique_id())
	
func connection_failed():
	print("Couldnt Connect")

func _host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 32)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	print("Waiting For Players!")
	
@rpc("any_peer")
func _set_new_player(id: int):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"Name": "None",
			"Color": Color(1, 1, 1, 1),
			"Territory": [],
			"Troops": {}
			}

	if multiplayer.is_server():
		GameManager.TotalPlayers += 1
		_send_player_information.rpc(GameManager.Players, GameManager.TotalPlayers)
	
@rpc("any_peer", "call_local")
func _send_player_information(player_info: Dictionary, total_players: int):
	GameManager.Players = player_info.duplicate(true)
	GameManager.TotalPlayers = total_players
	
	SignalBus.update_color_buttons.emit()
	SignalBus.update_ready_players_lobby.emit()
	
func _on_host_pressed() -> void:
	_host_game()
	_set_new_player(multiplayer.get_unique_id())
	_enter_lobby()

func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	_enter_lobby()
	
func _enter_lobby() -> void:
	pre_game.hide()
	lobby.show()

func _start_game() -> void:
	var scene = load("res://Scenes/MainBoard.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
