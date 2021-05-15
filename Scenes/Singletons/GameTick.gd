extends Node


func Tick(game):
	_do_ai_stars(game)
	_regen_ships(game)
	_do_orders(game)


func _regen_ships(game):
	for star in game["map"]["stars"]:
		match star["class"]:
			_:
				star["ships"] = Star.regen(star["ships"])


func _do_ai_stars(game):
	for star in game["map"]["stars"]:
		if star[""]


func _do_orders(game):
	pass
