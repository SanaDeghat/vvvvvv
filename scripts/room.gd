extends Area2D
var room_size=Vector2(1152,648)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	print("rwarr")
	camera.global_position =  global_position + room_size / 2.0
