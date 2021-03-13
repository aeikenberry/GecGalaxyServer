extends Node

const BASE_REGEN = .01

var regen_rate = 1.0
var attack_rate = 1.0
var move_rate = 1.0

func regen(ships):
	return ceil(ships * (BASE_REGEN + regen_rate))

func move(star1, star2):
	return [star1, star2]


func attack(star1, star2):
	return [star1, star2]
