extends Line2D

@export var positiveDirection := true
@export var speed := 120.0
@export var enemyNum := 1


@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var enemy_sprite: Sprite2D = $AnimatableBody2D/Enemy1

var t := 0.0
var dir := 1.0

var local_a := Vector2.ZERO
var local_b := Vector2.ZERO


func _ready() -> void:
	enemy_sprite.texture=load("res://assets/sprites/objects/enemies/enemy"+str(enemyNum)+".png")
	if points.size() < 2:
		return

	local_a = points[0]
	local_b = points[points.size() - 1]

	# Make collision match the sprite
	_build_collision_shape()

	# Shorten the movement path so the EDGE
	# of the enemy reaches the edge of the line.
	_adjust_movement_bounds()

	# Start at the correct end.
	t = 1.0 if positiveDirection else 0.0
	dir = -1.0 if positiveDirection else 1.0

	animatable_body_2d.position = local_a.lerp(local_b, t)


func _physics_process(delta: float) -> void:
	var length := local_a.distance_to(local_b)

	if length <= 0.0:
		return

	t += dir * (speed / length) * delta

	if t >= 1.0:
		t = 1.0
		dir = -1.0

	elif t <= 0.0:
		t = 0.0
		dir = 1.0

	animatable_body_2d.position = local_a.lerp(local_b, t)


func _adjust_movement_bounds() -> void:
	# Get the actual size of the sprite.
	var sprite_size := enemy_sprite.texture.get_size() * enemy_sprite.scale

	# Half-size along the movement direction.
	var half_size: float

	
	half_size = sprite_size.y * 0.5

	# Direction from A to B.
	var direction := (local_b - local_a).normalized()

	# Move the allowed center positions inward
	# by half the enemy's size.
	var offset := direction * half_size

	local_a += offset
	local_b -= offset


func _build_collision_shape() -> void:
	var rect := collision_shape_2d.shape as RectangleShape2D

	if rect == null:
		rect = RectangleShape2D.new()
		collision_shape_2d.shape = rect

	# Match collision to the sprite's actual size.
	var sprite_size := enemy_sprite.texture.get_size() * enemy_sprite.scale

	rect.size = sprite_size

	collision_shape_2d.position = Vector2.ZERO
