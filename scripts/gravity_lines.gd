extends Line2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	var segment = collision_shape_2d.shape as SegmentShape2D
	
	segment.a = points[0]
	segment.b = points[-1]

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.flip_gravity()
