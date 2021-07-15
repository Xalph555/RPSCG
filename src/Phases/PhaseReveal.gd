# ----------------------------------------- #
# Reveal Phase
# ----------------------------------------- #
extends Node2D

# Signal
# -----------------------------------------------
signal phase_end



# Variables
# -----------------------------------------------
onready var game_state = GameState
onready var parent = get_parent().get_parent()



# Functions:
# -----------------------------------------------
func run_phase():
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	parent.turn_field()
	yield(parent, "field_flipped")
	yield(get_tree().create_timer(2, false), "timeout")
	
	parent.turn_field(true)
	yield(parent, "field_flipped")
	
	emit_signal("phase_end")
