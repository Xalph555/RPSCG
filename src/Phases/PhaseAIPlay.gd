# ----------------------------------------- #
# AI Play Phase
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
	for i in range(3):
		var card = randi() % parent.deck_ai.hand_contents.size()
		var selected_card = parent.deck_ai.hand_contents[card]
		var board_position = parent.get_node("BoardPositions/FieldAI" + str(i))
		
		parent.deck_ai.place_card(card, i)
		parent.move_object(selected_card, board_position)
		selected_card.play_sound(selected_card.SOUNDS["move"])
		parent.rearrange_hand(parent.deck_ai)
		
		yield(parent.tween, "tween_all_completed")
	
	emit_signal("phase_end")
