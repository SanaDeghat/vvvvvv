extends Node2D

var gravity: Vector2 = Vector2(0.0, 3000.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_gravity() -> Vector2:
	return gravity

func set_gravity (new_gravity: Vector2):
	gravity=new_gravity
func change_gravity() -> void:
	
	gravity.y*=-1
	gravity.x*=-1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
