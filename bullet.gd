extends Node2D

const SPEED = 400

var direction = -1


func _physics_process(delta):
	var velocity = Vector2(1, 0).normalized() * direction * SPEED
	position += velocity * delta
	

func set_current_position(_position, _direction):
	position = _position	
	direction = _direction



func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
			queue_free()
