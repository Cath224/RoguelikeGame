extends Node2D

var player = preload("res://character.tscn")
var enemy = preload("res://enemy.tscn")
var enemy_2 = preload("res://enemy_2.tscn")
var enemy_3 = preload("res://enemy_3.tscn")

var room_1 = preload("res://room_1.tscn")
var room_2 = preload("res://room_2.tscn")
var room_3 = preload("res://room_3.tscn")
var room_4 = preload("res://room_4.tscn")
var room_5 = preload("res://room_5.tscn")
var room_6 = preload("res://room_6.tscn")
var room_7 = preload("res://room_7.tscn")

var rooms_positions = [[0, 0], [], []]
var rooms_to_select = [room_1, room_2, room_3, room_4, room_5, room_6, room_7]
var rooms_instances = [[null, null, null], [null, null, null], [null, null, null]]

var loading = false
var rng = RandomNumberGenerator.new()

func _ready():
	call_deferred("generate")

func generate():
	loading = true
	var rooms = [[null, null, null], [null, null, null], [null, null, null]]

	for i in range(0, 3):
		for j in range(0, 3):
			update_seed()
			var room_to_insert = rooms_to_select[rng.randi_range(0, 6)]
			
			rooms[i][j] = room_to_insert
			
	
	for i in range(0, 3):
		for j in range(0, 3):
			var room = rooms[i][j] as PackedScene
			var room_instance = room.instantiate() as Node2D
			room_instance.position = Vector2i(720 * i, 480 * j)
			add_child(room_instance)
			rooms_instances[i][j] = room_instance
	
	for room_row in rooms_instances:
		for room in room_row:
			var enemy_node = room.get_node("EnemyNode") as Node2D
			var markers = enemy_node.get_children()
			if markers == null || markers.is_empty():
				continue
			for marker in markers:
				var market_parsed = marker as Marker2D
				update_seed()
				var enemy_instance = null
				var random_enemy = rng.randi_range(0, 2)
				if random_enemy == 0:
					enemy_instance = enemy.instantiate() as Node2D
				elif random_enemy == 1:
					enemy_instance = enemy_2.instantiate() as Node2D
				elif random_enemy == 2:
					enemy_instance = enemy_3.instantiate() as Node2D
				else:
					continue;
				enemy_instance.position = market_parsed.global_position
				add_child(enemy_instance)
				
	
	update_seed()
	var player_pos_room = Vector2i(rng.randi_range(0, 2), rng.randi_range(0, 2))
	var player_instance = player.instantiate() as Node2D
	player_instance.position = rooms_instances[player_pos_room.x][player_pos_room.y].get_node('Marker2D').global_position 
	add_child(player_instance)
	loading = false


func _physics_process(delta):
	pass
	
func update_seed():
	rng.seed = rng.randi()
