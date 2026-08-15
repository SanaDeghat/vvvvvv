extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0


func _physics_process(delta: float) -> void:
	# Gravity
	velocity += global.get_gravity() * delta

	# Gravity change + spin
	if Input.is_action_just_pressed("ui_accept"):
		global.change_gravity()
		animated_sprite_2d.play("air-spin")

	# Movement
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

	# Only change animation if we're NOT currently doing the spin
	if animated_sprite_2d.animation != "air-spin" or not animated_sprite_2d.is_playing():
		if direction:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")
