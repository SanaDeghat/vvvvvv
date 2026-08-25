extends Line2D

@export var numOfblocks = 3
@export var positiveDirection := true
@export var orientation := 0 # 0 = horizontal, 1 = vertical
@export var speed := 120.0

@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var tile_map_layer: TileMapLayer = $AnimatableBody2D/TileMapLayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D

var t := 0.0
var dir := 1.0

var local_a := Vector2.ZERO
var local_b := Vector2.ZERO


func _ready() -> void:
	if points.size() < 2:
		return

	local_a = points[0]
	local_b = points[points.size() - 1]

	_build_platform_tiles()
	_build_collision_shape()

	# Shorten the movement path so the EDGE
	# of the platform reaches the edge of the line.
	_adjust_movement_bounds()

	# Start at the correct end.
	t = 1.0 if positiveDirection else 0.0
	dir = -1.0 if positiveDirection else 1.0

	animatable_body_2d.position = local_a.lerp(local_b, t)


func _physics_process(delta: float) -> void:
	var len := local_a.distance_to(local_b)

	if len <= 0.0:
		return

	t += dir * (speed / len) * delta

	if t >= 1.0:
		t = 1.0
		dir = -1.0

	elif t <= 0.0:
		t = 0.0
		dir = 1.0

	animatable_body_2d.position = local_a.lerp(local_b, t)


func _adjust_movement_bounds() -> void:
	var tile_size: Vector2 = Vector2(64, 64)

	if tile_map_layer.tile_set != null:
		tile_size = tile_map_layer.tile_set.tile_size

	var blocks = max(numOfblocks, 1)

	# Calculate the total platform size.
	var platform_size := Vector2(
		tile_size.x * (blocks if orientation == 0 else 1),
		tile_size.y * (1 if orientation == 0 else blocks)
	)

	# Half the platform's size along its movement axis.
	var half_platform_size: float

	if orientation == 0:
		half_platform_size = platform_size.x * 0.5
	else:
		half_platform_size = platform_size.y * 0.5

	# Direction from A to B.
	var direction := (local_b - local_a).normalized()

	# Move the allowed center positions inward
	# by half the platform size.
	var offset := direction * half_platform_size

	local_a += offset
	local_b -= offset


func _build_platform_tiles() -> void:
	tile_map_layer.clear()

	var tile_size: Vector2 = Vector2(64, 64)

	if tile_map_layer.tile_set != null:
		tile_size = tile_map_layer.tile_set.tile_size
	else:
		push_warning(
			"TileMapLayer.tile_set is not assigned; using fallback tile size 64x64."
		)

	var blocks = max(numOfblocks, 1)

	var axis := Vector2i(1, 0) if orientation == 0 else Vector2i(0, 1)

	var cells: Array[Vector2i] = []

	for i in range(blocks):
		cells.append(axis * i)

	tile_map_layer.set_cells_terrain_connect(
		cells,
		0,
		0
	)

	var total_size := Vector2(
		tile_size.x * (blocks if orientation == 0 else 1),
		tile_size.y * (1 if orientation == 0 else blocks)
	)

	tile_map_layer.position = -total_size * 0.5


func _build_collision_shape() -> void:
	var rect := collision_shape_2d.shape as RectangleShape2D

	if rect == null:
		rect = RectangleShape2D.new()
		collision_shape_2d.shape = rect

	var tile_size: Vector2 = Vector2(64, 64)

	if tile_map_layer.tile_set != null:
		tile_size = tile_map_layer.tile_set.tile_size

	var blocks = max(numOfblocks, 1)

	var total_size := Vector2(
		tile_size.x * (blocks if orientation == 0 else 1),
		tile_size.y * (1 if orientation == 0 else blocks)
	)

	# Make collision 1 pixel larger on each side.
	rect.size = total_size + Vector2(2, 2)

	collision_shape_2d.position = Vector2.ZERO
