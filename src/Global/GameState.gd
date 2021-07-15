# ----------------------------------------- #
# Game State
# ----------------------------------------- #

extends Node

# Signal
# -----------------------------------------------
signal state_changed(new_state)
signal score_changed_player(score)
signal score_changed_ai(score)



# Variables
# -----------------------------------------------
enum STATES {DRAW, 
			 AI_PLAY, 
			 PLAYER_PLAY,
			 REVEAL,
			 SWAP,
			 RESULTS}

var state_names = ["Draw", 
				   "AI Turn",
				   "Your Turn",
				   "Board Reveal",
				   "Card Swap",
				   "Results"]

var state_current = STATES.DRAW
var state_old = STATES.DRAW

var score_player = 0 setget set_score_player
var score_ai = 0 setget set_score_ai



# Functions:
# -----------------------------------------------
func state_transition(state_new):
	state_old = state_current
	state_current = state_new
	
	emit_signal("state_changed", state_new)


func set_score_player(new_score):
	score_player = new_score
	emit_signal("score_changed_player", new_score)


func set_score_ai(new_score):
	score_ai = new_score
	emit_signal("score_changed_ai", new_score)
