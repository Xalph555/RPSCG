# ----------------------------------------- #
# Scene Changer Script
# ----------------------------------------- #

extends CanvasLayer


# Signal
# -----------------------------------------------
signal scene_changed
signal fade_complete


# Variables
# -----------------------------------------------
onready var tween = $Tween
onready var black = $ColorRect



# Functions:
# -----------------------------------------------
func change_scene(path, duration = 1, delay = 0.5):
	fade_out(duration, delay)
	yield(self, "fade_complete")
	
	get_tree().change_scene(path)
	
	fade_in(duration, 0)
	yield(self, "fade_complete")
	
	emit_signal("scene_changed")


func fade_in(duration = 1, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(black, "modulate", 
							   Color(0, 0, 0, 1), Color(0, 0, 0, 0), 
							   duration,
							   tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	emit_signal("fade_complete")


func fade_out(duration = 1, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(black, "modulate", 
							   Color(0, 0, 0, 0), Color(0, 0, 0, 1), 
							   duration,
							   tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	emit_signal("fade_complete")
