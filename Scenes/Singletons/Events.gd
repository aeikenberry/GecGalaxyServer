extends Node

signal game_started()
signal game_starting_in(seconds)
signal game_updated(game)
signal player_disconnected(peer_id)
signal player_joined(peer_id, players)
