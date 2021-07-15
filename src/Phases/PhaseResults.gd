# ----------------------------------------- #
# Results Phase
# ----------------------------------------- #
extends Node2D

# Signal
# -----------------------------------------------
signal phase_end
signal sub_phase_end



# Variables
# -----------------------------------------------
onready var game_state = GameState
onready var parent = get_parent().get_parent()

onready var game_ui = get_node("../../BoardUI/UI/GameUI")
onready var results_ui = get_node("../../BoardUI/UI/ResultsUI")

onready var title_win = get_node("../../BoardUI/UI/ResultsUI/Title/TitleWin")
onready var title_lose = get_node("../../BoardUI/UI/ResultsUI/Title/TitleLose")
onready var title_draw = get_node("../../BoardUI/UI/ResultsUI/Title/TitleDraw")



# Functions:
# -----------------------------------------------
func run_phase():
	run_results()
	yield(self, "sub_phase_end")
	
	run_clean_up()
	yield(self, "sub_phase_end")
	
	emit_signal("phase_end")


func run_results():
	for i in range(parent.deck_player.field_contents.size()):
		if parent.deck_player.field_contents[i].will_win() == parent.deck_ai.field_contents[i].get_type():
			game_ui.spawn_marker(i, "win")
			game_state.score_player += 1
		
		elif parent.deck_player.field_contents[i].will_lose() == parent.deck_ai.field_contents[i].get_type():
			game_ui.spawn_marker(i, "lose")
			game_state.score_ai += 1
		
		else:
			game_ui.spawn_marker(i, "draw")
		
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	if game_state.score_player >= 3 or game_state.score_ai >= 3:
		results_ui.play_menu_reveal()
		
		title_win.visible = false
		title_lose.visible = false
		title_draw.visible = false
		
		if game_state.score_player == game_state.score_ai:
			title_draw.visible = true
			results_ui.play_result_sound(results_ui.SOUNDS["draw"])
			return
		
		if game_state.score_player > game_state.score_ai:
			title_win.visible = true
			results_ui.play_result_sound(results_ui.SOUNDS["win"])
			return
		
		if game_state.score_player < game_state.score_ai:
			title_lose.visible = true
			results_ui.play_result_sound(results_ui.SOUNDS["lose"])
			return
	
	yield(get_tree().create_timer(1, false), "timeout")
	
	game_ui.clear_markers()
	
	emit_signal("sub_phase_end")


func run_clean_up():
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
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	emit_signal("sub_phase_end")
