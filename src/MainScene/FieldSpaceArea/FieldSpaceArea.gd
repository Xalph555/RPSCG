# ----------------------------------------- #
# Field Space Area Script
# ----------------------------------------- #

extends Area2D

# Signals
# -----------------------------------------------
signal space_selected(space)


# Variables
# -----------------------------------------------
export (int) var field_position

var is_occupied = false
var interactable_states = [GameState.STATES.PLAYER_PLAY, 
						   GameState.STATES.SWAP]

onready var game_state = GameState
onready var highlight = $Sprite



# Functions:
# -----------------------------------------------
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not is_occupied and game_state.state_current in interactable_states:
			emit_signal("space_selected", field_position)


func _on_mouse_entered():
	if game_state.state_current in interactable_states:
		highlight.visible = true


func _on_mouse_exited():
	if game_state.state_current in interactable_states:
		highlight.visible = false
