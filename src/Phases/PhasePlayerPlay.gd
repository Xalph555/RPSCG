# ----------------------------------------- #
# Player Play Phase
# ----------------------------------------- #
extends Node2D

# Signal
# -----------------------------------------------
signal phase_end



# Variables
# -----------------------------------------------
var can_input = false

onready var game_state = GameState
onready var parent = get_parent().get_parent()



# Functions:
# -----------------------------------------------
func _ready():
	can_input = false
	set_process(false)


func _process(_delta):
	if is_field_occupied():
		can_input = false
		parent.get_node("FieldSpaces").visible = false
		parent.get_node("BoardUI/UI/GameUI/TitlePlayCards").visible = false
		
		set_process(false)
		yield(get_tree().create_timer(0.5, false), "timeout")
		
		emit_signal("phase_end")


func run_phase():
	reset_board()
	can_input = true
	
	parent.get_node("BoardUI/UI/GameUI/TitlePlayCards").visible = true
	set_process(true)


func is_field_occupied():
	for i in parent.get_node("FieldSpaces").get_children():
		if not i.is_occupied:
			return false
		
	return true


func _on_FieldSpaceArea_space_selected(space):
	if can_input:
		var selected_i = parent.deck_player.get_selected_hand()
		if selected_i == null: return
		
		var selected_card = parent.deck_player.hand_contents[selected_i]
		
		parent.deck_player.place_card(selected_i, space)
		selected_card.deselect()
		
		var field_space = parent.get_node("BoardPositions/FieldPlayer" + str(space))
		parent.move_object(selected_card, field_space)
		selected_card.play_sound(selected_card.SOUNDS["move"])
		parent.get_node("FieldSpaces/FieldSpaceArea" + str(space)).is_occupied = true
		
		selected_card.z_index = 0
		parent.rearrange_hand(parent.deck_player)


func reset_board():
	for i in parent.get_node("FieldSpaces").get_children():
		i.is_occupied = false
		i.highlight.visible = false
	
	parent.get_node("FieldSpaces").visible = true
