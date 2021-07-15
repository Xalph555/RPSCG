# ----------------------------------------- #
# Cleanup Phase
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
	for i in range(parent.deck_player.field_contents.size()):
		parent.deck_player.field_contents[i].face_down()
		parent.deck_ai.field_contents[i].face_down()
		yield(parent.deck_ai.field_contents[i], "card_flipped")
		
		parent.move_object(parent.deck_player.field_contents[i], parent.get_node("BoardPositions/DiscardPlayer"), Vector2.ZERO, 0.7)
		parent.deck_player.field_contents[i].play_sound(parent.deck_player.field_contents[i].SOUNDS["move"])
		parent.move_object(parent.deck_ai.field_contents[i], parent.get_node("BoardPositions/DiscardAI"), Vector2.ZERO, 0.7)
		parent.deck_ai.field_contents[i].play_sound(parent.deck_ai.field_contents[i].SOUNDS["move"])
		parent.deck_player.clear_card(i)
		parent.deck_ai.clear_card(i)
		
		yield(parent.tween, "tween_all_completed")
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	emit_signal("phase_end")
