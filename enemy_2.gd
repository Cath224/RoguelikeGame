extends Node2D

var movement_speed: float = 100.0
var movement_target_position: Vector2
var current_velocity = Vector2.ZERO
var	flip = false
var dead = false

@onready var navigation_agent: NavigationAgent2D = $EnemyBody/NavigationAgent2D



func _ready():
	navigation_agent.path_max_distance = 30
	navigation_agent.path_desired_distance = 30.0
	navigation_agent.target_desired_distance = 10.0
	movement_target_position = PlayerState.player_position
	PlayerState.connect("player_position_signal", player_position_changed)
	$EnemyBody/AnimatedSprite2D.play("idle")
	await get_tree().physics_frame


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _physics_process(delta):
	if dead:
		return
	if navigation_agent.is_navigation_finished():
		$EnemyBody/AnimatedSprite2D.play("idle")
		return
	

	var current_agent_position: Vector2 = $EnemyBody.global_position
	var new_velocity = current_agent_position.direction_to(navigation_agent.get_next_path_position()) * movement_speed
	
	if new_velocity.x < 0:
		$EnemyBody/AnimatedSprite2D.play("run_left")
	elif new_velocity.x > 0:
		$EnemyBody/AnimatedSprite2D.play("run_right")
	
	var steering = (new_velocity - current_velocity) * delta * 4.0 
	current_velocity += steering

	$EnemyBody.velocity = current_velocity
	$EnemyBody.move_and_slide()
	
	for i in range($EnemyBody.get_slide_collision_count()):
		var collision = $EnemyBody.get_slide_collision(i)
		var collider = collision.get_collider()
		if "Character" in collider.name:
			PlayerState.player_hurt(15)
			break

func player_position_changed(_position):
	movement_target_position = PlayerState.player_position
	set_movement_target(movement_target_position)
	
func die():
	await $EnemyBody/AnimatedSprite2D.animation_finished
	PlayerState.emit_enemy_death_changed()
	queue_free()


func _on_area_2d_area_entered(area):
	var parsed_area = area as Area2D
	if "bullet" in parsed_area.name:
		$EnemyBody/AnimatedSprite2D.play("death")
		dead = true
		die()
