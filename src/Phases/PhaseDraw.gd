# ----------------------------------------- #
# Draw Phase
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
	var draw_amount = 5 - parent.deck_player.hand_contents.size()
	
	for _i in range(draw_amount):
		if parent.deck_player.deck_contents.size() < 1:
			parent.deck_player.restore_discard()
			for i in parent.deck_player.deck_contents:
				parent.move_object(i, parent.get_node("BoardPositions/DeckPlayer"))
				
			parent.deck_player.play_sound(parent.deck_player.SOUNDS["restore"])
		
		parent.deck_player.draw_card()
		
		if parent.deck_ai.deck_contents.size() < 1:
			parent.deck_ai.restore_discard()
			for i in parent.deck_ai.deck_contents:
				parent.move_object(i, parent.get_node("BoardPositions/DeckAI"))
				
			parent.deck_ai.play_sound(parent.deck_ai.SOUNDS["restore"])
		
		parent.deck_ai.draw_card()
		
		yield(parent.tween, "tween_all_completed")
	
	emit_signal("phase_end")
