extends Node2D

signal start_signal()
signal exit_signal()

func _on_start_pressed():
	emit_signal("start_signal")


func _on_exit_pressed():
	emit_signal("exit_signal")
