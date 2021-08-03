extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

var players = {}

var host = null

# Called when the node enters the scene tree for the first time.
func _ready():
	StartServer()


func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")

	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	Events.connect("game_starting_in", self, "_game_starting_in")
	Events.connect("game_updated", self, "_game_updated")


func _game_starting_in(seconds):
	rpc("GameStartingIn", seconds)
	print("Game Starting in " + str(seconds))


func _game_updated(game):
	rpc("GameUpdate", game)


func _Peer_Connected(peer_id):
	print(str(peer_id) + " Peer Connected")
	rpc("GameUpdate", Game.GetGame())


func _Peer_Disconnected(peer_id):
	Events.emit_signal("player_disconnected", peer_id)
	print(str(peer_id) + " Peer Disconnected")
	players.erase(peer_id)

	if str(host.id) == str(peer_id):
		host = null

	if players.size() > 0:
		host = players.keys()[0]
		Game.SetHost(host)

	rpc("PlayerUpdate", players, host)

remote func SayHi(requestor):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnHi", "Hi", requestor)
	print("told " + str(player_id) + " hi")


remote func Register(name):
	var player_id = get_tree().get_rpc_sender_id()

	var player = {
		"name": name,
		"id": player_id,
		"ai": false
	}

	if players.empty():
		host = player
	elif host.ai:
		host = player
	elif not host:
		host = player
	else:
		print('host: ' + str(host))

	players[str(player_id)] = player

	rpc_id(player_id, "RegisterSuccess", "Joined")
	print("Conneced user " + str(player_id) + " as " + name)

	Game.SetHost(host)
	Events.emit_signal("player_joined", str(player_id), players)
	rpc("PlayerUpdate", players, host)


remote func StartGame(map_name):
	var player_id = get_tree().get_rpc_sender_id()

	if player_id != host.id:
		return

	Game.Start(players, map_name)
	rpc("GameStarting", players, map_name)

func GameStartingIn(seconds):
	rpc("GameStartingIn", seconds)

