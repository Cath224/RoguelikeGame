extends Node2D

signal win()


func _on_button_pressed():
	emit_signal("win")
