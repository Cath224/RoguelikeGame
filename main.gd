extends Node2D

var menu_scene = preload("res://main_menu.tscn")
var win_menu = preload("res://win_menu.tscn")
var lose_menu = preload("res://lose_menu.tscn")
var play_scene = preload("res://play_scene.tscn")
var menu_scene_instance
var play_scene_instance
var win_menu_instance
var lose_menu_instance
var killed_enemies = 0
var win_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_scene_instance = menu_scene.instantiate()
	add_child(menu_scene_instance)
	menu_scene_instance.connect("start_signal", start_game)
	menu_scene_instance.connect("exit_signal", exit_game)

func start_game():
	play_scene_instance = play_scene.instantiate()
	add_child(play_scene_instance)
	PlayerState.connect("player_death_signal", lose)
	PlayerState.connect("player_exit_signal", end_game_exit)
	PlayerState.connect("enemy_death_signal", kill_all_enemies)
	remove_child(menu_scene_instance)
	menu_scene_instance = null
	killed_enemies = 0


func end_game(state):
	win_state = false
	if state == "win":
		remove_child(win_menu_instance)
		win_menu_instance = null
	elif state == "exit":
		remove_child(play_scene_instance)
		play_scene_instance = null
	elif state == "lose":
		remove_child(lose_menu_instance)
		lose_menu_instance = null
	menu_scene_instance = menu_scene.instantiate()
	add_child(menu_scene_instance)
	menu_scene_instance.connect("start_signal", start_game)
	menu_scene_instance.connect("exit_signal", exit_game)

func kill_all_enemies():
	win()

func win():
	win_state = true
	win_menu_instance = win_menu.instantiate()
	add_child(win_menu_instance)
	win_menu_instance.connect("win", end_game_win)
	remove_child(play_scene_instance)
	play_scene_instance = null
	killed_enemies = 0
	
func lose():
	lose_menu_instance = lose_menu.instantiate()
	add_child(lose_menu_instance)
	lose_menu_instance.connect("lose", end_game_lose)
	remove_child(play_scene_instance)
	play_scene_instance = null

func end_game_win():
	end_game("win")

func end_game_exit():
	end_game("exit")
	
	
func end_game_lose():
	end_game("lose")
	
func exit_game():
	get_tree().quit()
