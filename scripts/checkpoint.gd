extends StaticBody2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@export var active :=false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("checkpoints")
	if active: 
		animations.play("activated")
	else:
		animations.play("deactive")
func activate():
	if !active:
		get_tree().call_group("checkpoints", "deactivate")
		active=true
		animations.play("activate")
		await animations.animation_finished
		animations.play("activated")

func deactivate():
	if active:
		animations.play("deactivate")
		await animations.animation_finished
		animations.play("deactive")
		active=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
