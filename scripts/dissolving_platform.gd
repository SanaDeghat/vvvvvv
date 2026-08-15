extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var respawn_timer: Timer = $respawnTimer
@onready var dissolve_timer: Timer = $dissolveTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass







func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !collision_shape_2d.disabled:
		print("yippee yoo or yippeee ye")
		dissolve_timer.start()


func _on_respawn_timer_timeout() -> void:
	print("respawn timer timout")
	collision_shape_2d.disabled=false


func _on_dissolve_timer_timeout() -> void:
	collision_shape_2d.disabled=true
	respawn_timer.start()
	print ("respawn timer start")
