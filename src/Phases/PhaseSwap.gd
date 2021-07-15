# ----------------------------------------- #
# Swap Phase
# ----------------------------------------- #
extends Node2D

# Signal
# -----------------------------------------------
signal phase_end



# Variables
# -----------------------------------------------
var num_selected = 0

onready var game_state = GameState
onready var parent = get_parent().get_parent()



# Functions:
# -----------------------------------------------
func _ready():
	set_process(false)


func _process(_delta):
	num_selected = parent.deck_player.get_selected_field().size()
	
	if num_selected == 2:
		parent.get_node("BoardUI/UI/GameUI/ButtonSwap").visible = true
		parent.get_node("BoardUI/UI/GameUI/ButtonSkipSwap").visible = false
		
	elif num_selected == 1:
		parent.get_node("BoardUI/UI/GameUI/ButtonSwap").visible = false
		parent.get_node("BoardUI/UI/GameUI/ButtonSkipSwap").visible = false
		
	else:
		parent.get_node("BoardUI/UI/GameUI/ButtonSwap").visible = false
		parent.get_node("BoardUI/UI/GameUI/ButtonSkipSwap").visible = true


func run_phase():
	parent.get_node("BoardUI/UI/GameUI/TitleSwapIndi").visible = true
	set_process(true)


func _on_ButtonSwap_pressed():
	parent.get_node("BoardUI/UI/GameUI/ButtonSwap").visible = false
	parent.get_node("BoardUI/UI/GameUI/ButtonSkipSwap").visible = false
	parent.get_node("BoardUI/UI/GameUI/TitleSwapIndi").visible = false
	set_process(false)
	
	var ai_selection_space = parent.deck_ai.field_contents.size()
	var ai_swaps = [randi() % ai_selection_space, randi() % ai_selection_space]
	
	var p_swaps = parent.deck_player.get_selected_field()
	if p_swaps.size() == 2:
		parent.deck_player.field_contents[p_swaps[0]].deselect()
		parent.deck_player.field_contents[p_swaps[1]].deselect()
	
	parent.turn_field()
	yield(parent, "field_flipped")
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	if p_swaps.size() == 2:
		var player_p1 = parent.deck_player.field_contents[p_swaps[0]]
		var player_p2 = parent.deck_player.field_contents[p_swaps[1]]
		parent.move_object(player_p1, parent.get_node("BoardPositions/FieldPlayer" + str(p_swaps[1])))
		player_p1.play_sound(player_p1.SOUNDS["move"])
		parent.move_object(player_p2, parent.get_node("BoardPositions/FieldPlayer" + str(p_swaps[0])))
		player_p2.play_sound(player_p2.SOUNDS["move"])
		parent.deck_player.swap_cards(p_swaps[0], p_swaps[1])
	
	var ai_p1 = parent.deck_ai.field_contents[ai_swaps[0]]
	var ai_p2 = parent.deck_ai.field_contents[ai_swaps[1]]
	if ai_p1 != ai_p2:
		parent.move_object(ai_p1, parent.get_node("BoardPositions/FieldAI" + str(ai_swaps[1])))
		ai_p1.play_sound(ai_p1.SOUNDS["move"])
		parent.move_object(ai_p2, parent.get_node("BoardPositions/FieldAI" + str(ai_swaps[0])))
		ai_p2.play_sound(ai_p2.SOUNDS["move"])
		parent.deck_ai.swap_cards(ai_swaps[0], ai_swaps[1])
	
	if p_swaps.size() == 2 or ai_p1 != ai_p2: 
		yield(parent.tween, "tween_all_completed")
	
	yield(get_tree().create_timer(1, false), "timeout")
	
	emit_signal("phase_end")
