# ----------------------------------------- #
# Card Front Face Script
# ----------------------------------------- #
extends Area2D


# Signals
# ----------------------------------------------
signal card_selected
signal card_hovered
signal card_not_hovered



# Variables
# -----------------------------------------------
onready var game_state = GameState



# Functions:
# -----------------------------------------------
func _ready():
	pass


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("card_selected")


func _on_mouse_entered():
	emit_signal("card_hovered")

func _on_mouse_exited():
	emit_signal("card_not_hovered")
