extends Node


var maps = {
	"doon": "res://Maps/doon.json"
}

func GetMapData(map_name):
	return _load_map_json(maps[map_name])

func _load_map_json(asset_path):
	var file = File.new()
	file.open(asset_path, File.READ)
	var map_text = file.get_as_text()
	file.close()
	
	return JSON.parse(map_text).result
