extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player = null

export var Hp = 100

var Driving = false

var WheelRot = 0

var Velocity = Vector2()

export var AccelSpeed = 15

var Stopping = false

var Velbef = Vector2()


export (Texture) var texture



func _ready():
	$Sprite.texture = texture
	
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	Velbef = linear_velocity
	if Player != null:
		if Driving:
			$Particles2D.emitting = true

			linear_velocity += Vector2(0,1).rotated(rotation) *  Player.MoveDir.y * AccelSpeed
			WheelRot=Player.MoveDir.x*90
			WheelRot = clamp(WheelRot,-45,45)
			rotate(WheelRot*delta *(linear_velocity.length() *0.0001))
			
			Player.position = position
	else:
		$Particles2D.emitting = false
	var forwardVelocity = Vector2.UP.rotated(rotation) * linear_velocity.dot( Vector2.UP.rotated(rotation))
	var rightVelocity = Vector2.RIGHT.rotated(rotation) * linear_velocity.dot(Vector2.RIGHT.rotated(rotation))
	linear_velocity = forwardVelocity + rightVelocity * 0.95;
	$RayCast2D.cast_to = linear_velocity.normalized() * 50
	$RayCast2D.global_rotation = 0
	if $RayCast2D.is_colliding():
		if linear_velocity.length() <= -1:
			if Player != null:
					Driving = false
					Player.state = Player.STATES.default
					Player.get_node("CollisionShape2D").disabled = false
					Player.get_node("Camera2D").offset = Vector2()
			queue_free()

func _on_GetIn_body_entered(body):
	if body.is_in_group("Player"):
		if not body.is_in_group("Bullet"):
			Player = body
			Player.Car = self


func _on_GetIn_body_exited(body):
	if body.is_in_group("Player"):
		if not body.is_in_group("Bullet"):
			if not Driving:
				if Player.Car == self:
					Player.Car = null
					Player = null
			



func _on_Car_body_entered(body):
	var explosion = load("res://scenes/Explosion.tscn")
	
	Hp -= 10
	
	
	if Hp <= 0:
			if Player != null:
					Driving = false
					Player.GetOutOfCar()
			queue_free()
