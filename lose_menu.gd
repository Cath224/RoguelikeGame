extends Node2D

signal lose()

func _on_button_pressed():
	emit_signal("lose")
