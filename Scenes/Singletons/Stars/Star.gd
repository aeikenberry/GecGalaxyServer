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
	var attack_rate = (star2.ships / star1.ships) * .1
	var removed_ships = star2.ships * attack_rate
	if removed_ships > star2.ships:
		removed_ships = star2.ships
	star1.ships += removed_ships
	star2.ships -= removed_ships
	return [star1, star2]
