extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum STATES {walk,agro,search}


var State = STATES.search

var Spath = []
var Velocity = Vector2()
var Dir = Vector2()

export (PoolVector2Array) var path = []

var PathIndex =0

var HP = 100

onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
		print("d")
		print(global.Player)
		call_deferred("GetPath")
func _physics_process(delta):
	Velocity = lerp(Velocity,Vector2(),0.25)
	
	match State:
		STATES.search:
			Search()
		STATES.walk:
			Walk()
		STATES.agro:
			Agro()
		
	$Sprite.rotation = lerp($Sprite.rotation, Dir.angle(),0.1)
	
	
	move_and_slide(Velocity,Vector2.UP,false,4,0.785398,false)
	$Line2D.global_position = Vector2()
	PlayAnim()
func Agro():
	pass
func Walk():
	if Spath.size() > 0:
		$Line2D.points = Spath
		if position.distance_to(Spath[0]) <= 3:
			Spath.remove(0)
		if Spath.size() > 0:
			Dir = position.direction_to(Spath[0])
		
		Velocity += Dir * 20
	else:
		if path.size() > 0:
			PathIndex += 1
			if PathIndex >= path.size():
				PathIndex = 0
			GetPath(path[PathIndex])
func Search():
	if Spath.size() > 0:
		
		$Line2D.points = Spath
		
		if position.distance_to(Spath[0]) <= 3:
			Spath.remove(0)
		if Spath.size() > 0:
			Dir = position.direction_to(Spath[0])
		Velocity += Dir * 40
func PlayAnim():
	$AnimationPlayer.play("Idle")

func GetPath(targ):
	Spath = global.Nav.get_simple_path(position, targ , false)

	
	
func Hit(dam):
	HP -= dam
	if HP <= 0:
		queue_free()


func _on_Timer_timeout():
	GetPath(global.Player.position)


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Bullet"):
		if area.get_parent().is_in_group("Player"):
			
			Hit(area.get_parent().Damage)
			area.get_parent().queue_free()
