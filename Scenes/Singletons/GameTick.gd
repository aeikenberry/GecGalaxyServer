extends Node


func Tick(game):
	_do_orders(game)
	_regen_ships(game)
	var player = _check_end(game)
	if player != null:
		Events.emit_signal("game_won", player)


func _regen_ships(game):
	for star in game["map"]["stars"]:
		var ships_to_regen = Star.ships_to_regen(star)
		star["ships"] = ships_to_regen


func _do_orders(game):
	print("Doing tick")
	for star in game["map"]["stars"]:
		if star.player == null:
			continue
		var player = Game.players[star.player]
		if player.ai:
			Star.DoAIOrder(star)
		else:
			Star.DoOrder(star)

func _check_end(game):
	var owners = []
	for star in game["map"]["stars"]:
		owners.append(star.player)
	
	if len(owners) == 1:
		return owners[0]
	
	return null
