extends Node2D

var gravity: Vector2 = Vector2(0.0, 980.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_gravity() -> Vector2:
	return gravity

func set_gravity (new_gravity: Vector2):
	gravity=new_gravity
func change_gravity(mode:int) -> void:
	if (mode==0):
		gravity.y*=-1
	elif (mode==1):
		gravity.x*=-1
	gravity= Vector2(0.0, 980.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
