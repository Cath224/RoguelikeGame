extends Node2D


func get_room_access(name):
	if name == null:
		return null
	if 'room_1' in name:
		return [[false, false, true], [true, true, true], [false, false, false]]
	elif 'room_2' in name:
		return [[true, true, true], [false, false, true], [false, false, true]]
	elif 'room_3' in name:
		return  [[false, false, false], [true, true, true], [false, false, false]]
	elif 'room_4' in name:
		return  [[false, false, false], [false, false, false], [true, true, true]]
	elif 'room_5' in name:
		return  [[false, true, false], [false, true, false], [false, true, false]]
	elif 'room_6' in name:
		return  [[false, true, false], [true, true, true], [false, true, false]]
	elif 'room_7' in name:
		return  [[false, false, false], [false, false, false], [false, false, false]]
	return null
