extends Node2D



func _on_health_body_entered(body):
	var body_node = body as CharacterBody2D
	if body_node != null && 'CharacterBody2D' in body_node.name:
		PlayerState.health_up(25)
		queue_free()
