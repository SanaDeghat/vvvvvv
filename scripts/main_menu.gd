extends Node2D

@onready var ui_person_leg_2: Sprite2D = $UiPersonLeg2
@onready var ui_person_leg_1: Sprite2D = $UiPersonLeg1

var sway_speed := 3.0        
var sway_amount := deg_to_rad(10) 

func _process(delta: float) -> void:
	# time-based oscillation
	var t = Time.get_ticks_msec() / 1000.0

	# left/right sway using sine wave
	ui_person_leg_1.rotation = sin(t * sway_speed) * sway_amount
	ui_person_leg_2.rotation = sin(t * sway_speed + PI) * sway_amount
