# ----------------------------------------- #
# UI Script
# ----------------------------------------- #
extends Control


# Signal
# -----------------------------------------------
signal title_rev_done
signal game_paused
signal game_resumed



# Variables
# -----------------------------------------------
var is_game_paused = false

onready var game_state = GameState
onready var parent = get_node("/root/Game")

onready var game_ui = $GameUI
onready var results_ui = $ResultsUI
onready var pause_ui = $PauseUI



# Functions:
# -----------------------------------------------
func turn_start():
	game_ui.reveal_state_title()


func game_resume():
	if is_game_paused:
		is_game_paused = false
		get_tree().paused = false
		emit_signal("game_resumed")


func game_pause():
	if not is_game_paused:
		is_game_paused = true
		get_tree().paused = true
		emit_signal("game_paused")
