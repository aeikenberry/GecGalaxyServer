extends Node

var map = {"stars": [], "players": 2, "name": "cool"}
var players = {}
var tick_timer
var started = false
var start_time
var host

var game = { 
	"map": map, 
	"players": players, 
	"started": started, 
	"start_time": start_time,
	"host": host
}


func _ready():
	Events.connect("player_disconnected", self, "_on_player_disconnected")
	Events.connect("player_joined", self, "_on_player_connected")


func _on_player_connected(peer_id, players):
	for player_id in players:
		var player = players[player_id]
		if player.ai:
			players.erase(player)
			
			for star in game.map.stars:
				if star.player == str(player.id):
					star.player = peer_id
			# only remove 1
			break
	Events.emit_signal("game_updated", game)


func _on_player_disconnected(peer_id):
	var removed = players.erase(str(peer_id))
	
	if removed and players.size() < game.map.players:
		var new_key = "AI_" + str(peer_id)
		var player = {
			"name": "AI",
			"ai": true,
			"id": new_key,
		}
		players[new_key] = player
		for star in game.map.stars:
			if star.player == str(peer_id):
				star.player = new_key
	
	Events.emit_signal("game_updated", game)


func GetGame():
	return game


func SetHost(_host):
	host = _host
	game["host"] = host
	Events.emit_signal("game_updated", game)


func Start(player_data, map_name):
	if started:
		print("Cannot start game, already in progress...")
		return

	_setup_game(player_data, map_name)
	Events.emit_signal("game_updated", game)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 5)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 4)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 3)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 2)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 1)
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("game_starting_in", 0)
	_start_timer()


func _start_timer():
	tick_timer = Timer.new()
	tick_timer.autostart = true
	tick_timer.wait_time = 1.0
	tick_timer.connect("timeout", self, "_game_tick")
	
	add_child(tick_timer)
	start_time = OS.get_time()
	started = true
	game["start_time"] = start_time
	game["started"] = started
	Events.emit_signal("game_updated", game)


func _game_tick():
	GameTick.Tick(game)
	Events.emit_signal("game_updated", game)


func _setup_game(player_data, map_name):
	map = MapLoader.GetMapData(map_name)
	players = player_data
	game["map"] = map
	Map.SetStars(map["stars"])
	_set_game_players()
	_set_starting_players()
	Events.emit_signal("game_updated", game)


func _set_game_players():
	var map_players = map.players
	var mapped_players = 0
	var player_size = players.size()
	
	if map_players == player_size:
		game.players = players
	elif map_players > player_size:
		# Will need to add AI Players
		var added = 0
		
		game.players = players
		while added < map_players - player_size:
			var player = {
				"name": "AI",
				"ai": true,
				"id": str(added) + "_AI",
			}
			game.players[player.id] = player
			added += 1
	else:
		# map_players is max. add the first players
		var new_players = {}
		var added = 0
		for peer_id in players.keys():
			if added < map_players:
				new_players[peer_id] = players[peer_id]
				added += 1
		game.players = new_players
	
	Events.emit_signal("game_updated", game)
	

func _set_starting_players():
	var player_ids = game.players.keys()
	
	for star in game.map.stars:
		if star.player != null:
			var player_index = int(star.player)
			star.player = player_ids[player_index]
