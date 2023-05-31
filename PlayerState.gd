extends Node2D

var player_position = Vector2(0, 0)
const DEFAULT_PLAYER_HEATH = 100
var player_heath = DEFAULT_PLAYER_HEATH
var enemy_dead = 0

signal player_position_signal(player_position)
signal player_hurt_signal()
signal player_death_signal()
signal player_exit_signal()
signal enemy_death_signal()
signal health_up_signal()
signal enemy_killed_signal()

func player_init():
	player_heath = DEFAULT_PLAYER_HEATH
	enemy_dead = 0

func player_hurt(harm):
	player_heath -= harm
	if player_heath <= 0:
		emit_signal("player_hurt_signal")
		PlayerState.emit_player_death_changed()
	else:
		emit_signal("player_hurt_signal")

func player_position_changed(position):
	player_position = position
	emit_player_position_changed()

func emit_player_position_changed():
	emit_signal("player_position_signal", player_position)
	
func emit_player_death_changed():
	emit_signal("player_death_signal")
	
func emit_player_exit_changed():
	emit_signal("player_exit_signal")
	
	
func emit_enemy_death_changed():
	enemy_dead += 1
	emit_signal("enemy_killed_signal")
	if enemy_dead == 25:
		emit_signal("enemy_death_signal")

func health_up(amount):
	if amount == 0:
		return
	var updated_health = player_heath + amount
	if updated_health > 100:
		player_heath = 100
	else:
		player_heath = updated_health
	emit_signal("health_up_signal")
