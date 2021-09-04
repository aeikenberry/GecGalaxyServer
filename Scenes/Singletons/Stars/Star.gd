extends Node

const BASE_REGEN = .01

var regen_rate = 1.0
var attack_rate = 1.0
var move_rate = 0.1


func ships_to_regen(star):
	match star["class"]:
			_:
				return ceil(star.ships * (BASE_REGEN + regen_rate))


func get_ships_to_move(star):
	match star["class"]:
			_:
				return ceil(star.ships * move_rate)


func DoOrder(star):
	if not star.orders:
		return
	
	var other_star = Map.GetStarByID(star.orders)
	
	if other_star.player == star.player:
		return move(star, other_star)
	
	return attack(star, other_star)


func DoAIOrder(star):
	var target_star = AiPlayer.GetTarget(star)
	
	if target_star.player == star.player:
		return move(star, target_star)
	
	return attack(star, target_star)


func move(star, target):
	var ships_to_move = Star.get_ships_to_move(star)
	
	target["ships"] = target["ships"] + ships_to_move
	star["ships"] = star["ships"] - ships_to_move
	print("MOVING: ship: " + str(star.id) + " to: " + str(target.id) + 
		" ships: " + str(ships_to_move))
	
	return [star, target]


func attack(star1, star2):
	var removed_ships = ceil(star2.ships - star1.ships)
	if removed_ships > star2.ships:
		removed_ships = star2.ships
	elif removed_ships == 0:
		print("0")
		removed_ships = 10
	if removed_ships > 0:
		star2.ships -= removed_ships
	else:
		if removed_ships > star1.ships:
			star1.ships = 0
		else:
			star1.ships -= abs(float(removed_ships))
	
	if star1.ships == 0:
		star1.player = star2.player
	elif star2.ships == 0:
		star2.player = star1.player

	return [star1, star2]
