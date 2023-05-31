extends Node2D

@onready var bullet_scene = preload("res://bullet.tscn")

const SPEED = 300
var SCREEN_SIZE = DisplayServer.window_get_size()
var flip = false
var attack = false
var direction = 1


func _ready():
	PlayerState.player_init()
	PlayerState.player_position_changed($CharacterBody2D.global_position)
	$CharacterBody2D/AnimatedSprite2D.play("idle")
	$CharacterBody2D/Camera2D/TextureProgressBar.value = PlayerState.player_heath
	PlayerState.connect("player_hurt_signal", hurt)
	PlayerState.connect("health_up_signal", health_up)
	PlayerState.connect("enemy_killed_signal", kill_enemy)


func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_pressed("exit"):
		PlayerState.emit_player_exit_changed()
	if PlayerState.player_heath == 0:
		return
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x = 1
		direction = 1
		flip = true	
	elif Input.is_action_pressed("move_left"):
		velocity.x = -1
		direction = -1
		flip = false
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	
	if velocity.length() > 0:
		$CharacterBody2D.velocity = velocity.normalized() * SPEED
		$CharacterBody2D/AnimatedSprite2D.flip_h = flip
		if flip:
			$CharacterBody2D/Marker2D.position = Vector2($CharacterBody2D/AnimatedSprite2D.position.x + 16, $CharacterBody2D/AnimatedSprite2D.position.y)
		else:
			$CharacterBody2D/Marker2D.position = Vector2($CharacterBody2D/AnimatedSprite2D.position.x - 16, $CharacterBody2D/AnimatedSprite2D.position.y)
		$CharacterBody2D.move_and_slide()
		$CharacterBody2D/AnimatedSprite2D.play("run")
		PlayerState.player_position_changed($CharacterBody2D.global_position)
	else:
		$CharacterBody2D/AnimatedSprite2D.flip_h = flip
		$CharacterBody2D/AnimatedSprite2D.play("idle_left")
			
	if Input.is_action_pressed("attack"):
		$CharacterBody2D/AnimatedSprite2D.play("attack")
	if Input.is_action_just_pressed("attack"):
		var bullet = bullet_scene.instantiate()
		bullet.set_current_position($CharacterBody2D/Marker2D.position, direction)
		$CharacterBody2D.add_child(bullet)

func kill_enemy():
	$CharacterBody2D/Camera2D/Label.text = str(PlayerState.enemy_dead) + "/25"
	
func health_up():
	$CharacterBody2D/Camera2D/TextureProgressBar.value = PlayerState.player_heath

func hurt():
	var animation_name;
	if flip:
		animation_name = "hurt_right"
	else:
		animation_name = "hurt_left"
	$CharacterBody2D/AnimatedSprite2D.play(animation_name)
	$CharacterBody2D/Camera2D/TextureProgressBar.value = PlayerState.player_heath
