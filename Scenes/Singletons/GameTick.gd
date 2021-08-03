extends Node


func Tick(game):
	_do_orders(game)
	_regen_ships(game)


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
