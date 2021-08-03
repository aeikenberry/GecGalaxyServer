extends Node

var _stars = {}
var _players = {}
var _name = {}


func GetStarByID(star_id):
	return _stars[star_id]

func SetStars(stars):
	for star in stars:
		star.orders = null
		_stars[star["id"]] = star

func SetPlayers(players):
	_players = players
