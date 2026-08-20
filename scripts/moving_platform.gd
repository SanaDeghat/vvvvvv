extends Line2D

@export var numOfBlocks := 3
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

	t = 1.0 if positiveDirection else 0.0
	dir = -1.0 if positiveDirection else 1.0

	_build_platform_tiles()
	_build_collision_shape()

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

func _build_platform_tiles() -> void:
	tile_map_layer.clear()

	var axis := Vector2i(1, 0) if orientation == 0 else Vector2i(0, 1)
	var half := numOfBlocks / 2
	var cells: Array[Vector2i] = []

	for i in range(numOfBlocks):
		cells.append(axis * (i - half)) # centered around (0,0)

	tile_map_layer.set_cells_terrain_connect(cells, 0, 0) # first terrain set, first terrain

func _build_collision_shape() -> void:
	var rect := collision_shape_2d.shape as RectangleShape2D
	if rect == null:
		rect = RectangleShape2D.new()
		collision_shape_2d.shape = rect

	var tile_size: Vector2 = tile_map_layer.tile_set.tile_size
	var blocks = max(numOfBlocks, 1)

	if orientation == 0:
		rect.size = Vector2(tile_size.x * blocks, tile_size.y)
	else:
		rect.size = Vector2(tile_size.x, tile_size.y * blocks)

	collision_shape_2d.position = Vector2.ZERO
