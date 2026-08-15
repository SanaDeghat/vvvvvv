extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
var last_checkbox_location := Vector2(540,184)

var was_on_floor := true
var gravity_changing := false

func respawn():
	global_position=last_checkbox_location
func _physics_process(delta: float) -> void:
	velocity += global.get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not gravity_changing:
		global.change_gravity()
		up_direction *= -1
		
		gravity_changing = true
		animated_sprite_2d.play("jump-start")

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED

		if direction < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	var on_floor_now := is_on_floor()

	if not was_on_floor and on_floor_now:
		gravity_changing = false
		animated_sprite_2d.play("land")

	was_on_floor = on_floor_now

	if gravity_changing:

		if animated_sprite_2d.animation == "jump-start" and not animated_sprite_2d.is_playing():
			
			animated_sprite_2d.flip_v = up_direction == Vector2.DOWN
			
			animated_sprite_2d.play("air-spin")


	elif animated_sprite_2d.animation == "land" and not animated_sprite_2d.is_playing():
		if direction:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")

	elif not gravity_changing and animated_sprite_2d.animation != "land":
		if direction:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")




func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("check")


	


func _on_checkpoint_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.activate()
	last_checkbox_location=body.global_position
