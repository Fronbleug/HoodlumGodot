extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum STATES {default, car}

var Car = null


var state = STATES.default


var Velocity = Vector2()
var FacingDir = Vector2()
var MoveDir = Vector2()
onready var Bullet = preload("res://scenes/objects/Bullet.tscn")
onready var anim_player = $AnimationPlayer

onready var GunSprite = preload("res://sprites/objects/player/PlayerGun.png")
onready var NormalSprite = preload("res://sprites/objects/player/Player.png")

var MoveSpeed = 100

var camzoom = 0.5

var WalkSpeed = 30
var RunSpeed = 60

var Sprint = false

var Moving = false

var Aim = false

var ShootTime = 0



func _ready():
	global.Player = self
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	
	$Camera2D.zoom = lerp($Camera2D.zoom,Vector2(camzoom,camzoom),0.5)
	
	MoveDir.x = Input.get_axis("ui_left","ui_right")
	MoveDir.y = Input.get_axis("ui_up","ui_down")
	Sprint = Input.is_action_pressed("Sprint")
	
	Aim = Input.is_action_pressed("Aim")
	match state:
		STATES.default:
			
			if Car != null:
				if Input.is_action_just_pressed("CarButton"):
					camzoom = 0.75
					Car.Driving = true
					state = STATES.car
					$CollisionShape2D.disabled = true
			
			
			look_at(get_global_mouse_position())
			Velocity = lerp(Velocity, Vector2(), 0.25)

			
	
			
	
	
			if Sprint:
				MoveSpeed = RunSpeed
				anim_player.playback_speed = 2
			else:
				MoveSpeed = WalkSpeed
				anim_player.playback_speed = 1
			Velocity += MoveDir * MoveSpeed
	
	
			ShootTime -= delta
			if Aim:
				if Input.is_action_just_pressed("Shoot"):
			
					if ShootTime <= 0:
						Shoot()
						ShootTime = 0.25
		STATES.car:
			if Input.is_action_just_pressed("CarButton"):
					Car.Driving = false
					state = STATES.default
					$CollisionShape2D.disabled = false
					$Camera2D.offset = Vector2()
					camzoom = 0.5
			$Camera2D.offset.x = lerp($Camera2D.offset.x,Car.linear_velocity.x /3,0.1)
			$Camera2D.offset.y = lerp($Camera2D.offset.y,Car.linear_velocity.y  /3,0.1)
			Velocity = Vector2()
	Velocity = move_and_slide(Velocity,Vector2.UP,false,4,0.785398,false)
	if MoveDir != Vector2():
		Moving = true
	else:
		Moving= false
	if Aim:
		if $Sprite.texture != GunSprite:
			$Sprite.texture = GunSprite
	else:
		if $Sprite.texture != NormalSprite:
			$Sprite.texture = NormalSprite
	PlayAnim()
func PlayAnim():
	
	if Moving:
		anim_player.play("Walk")
	else:
		anim_player.play("Idle")
	
func Shoot():
	var b = Bullet.instance()
	b.Start(position,500,Vector2(1,0).rotated(rotation),"Player")
	b.add_to_group("Player")
	get_parent().add_child(b)
