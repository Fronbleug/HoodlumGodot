extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Speed = 0
var Velocity = Vector2()

var Source = null

var Damage = 25
# Called when the node enters the scene tree for the first time.
func Start(pos, speed, rot, group):
	add_to_group(group)
	position = pos
	rotation = rot.angle()
	Speed = speed
	Velocity = rot * speed
func _physics_process(delta):
	move_and_slide(Velocity)





func _on_Area2D_body_entered(body):
	if body.is_in_group("Wall"):
		if Source != null:
			Source.position = position
		queue_free()
