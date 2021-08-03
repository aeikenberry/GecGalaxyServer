extends Node

func GetTarget(star):
	"""
	Typically, we want to be expand or attacking as a team.
		A. Get the stars adjacent to me that are not owned by me.
			- Attack the one with the smallest ships
		B. If there're all mine around me,
			1. walk the connections to find the paths that lead to
			   one of my stars with an adjacent enemy star.
			2. Pick the shortest path, and move ships to the first star in the path.

	Return star with new orders.
	"""
	# Try to attack immediate adjacent first
	var to_attack = get_adjacent_star_to_attack(star)
	print("TO ATTACK: " + str(to_attack))
	if to_attack == null:
		# move to the star with the closest path to an enemy
		to_attack = get_adjacent_star_to_move_to(star)
		print("finding thing to move")
		print(to_attack)

	return to_attack


func get_adjacent_star_to_move_to(star):
	var paths = {}

	for star_id in star.connections:
		var cur_star = Map.GetStarByID(star_id)

		# Create path
		paths[cur_star] = _walk_star(cur_star, 0)

	var shortest_star = null
	var shortest_distance = null

	for _star in paths:
		var distance = paths[_star]

		if not shortest_star:
			shortest_star = _star
			shortest_distance = distance
		else:
			if distance < shortest_distance:
				shortest_star = _star
				shortest_distance = distance

	return shortest_star


func _walk_star(star, count):
	count += 1
	print("walking: " + str(star.id) + " count: " + str(count))

	for star_id in star.connections:
		if star_id == star.id:
			return count

		var cur_star = Map.GetStarByID(star_id)

		if star.player != cur_star.player:
			return count

		return _walk_star(cur_star, count)


func get_adjacent_stars(star):
	var adjacent_stars = []
	for star_id in star["connections"]:
		adjacent_stars.append(Map.GetStarByID(star_id))

	return adjacent_stars

func get_adjacent_star_to_attack(star):
	"""
	Find adjacent enemy stars, pick lowest ship count
	"""
	var stars = get_adjacent_stars(star)
	var found = null

	for s in stars:
		if s["player"] != star["player"]:
			if found and found["ships"] > s["ships"]:
				found = s
			if not found:
				found = s

	return found
