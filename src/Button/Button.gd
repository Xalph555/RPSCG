# ----------------------------------------- #
# Button Script
# ----------------------------------------- #

extends Button


# Variables
# -----------------------------------------------
onready var sound = $AudioStreamPlayer



# Functions:
# -----------------------------------------------
func _on_pressed():
	sound.play()
