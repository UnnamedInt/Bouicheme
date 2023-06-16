@tool
class_name Canon
extends StaticBody2D

enum direction {RIGHT, LEFT, UP, DOWN}

const movementVectors = {
	direction.RIGHT: Vector2.RIGHT,
	direction.LEFT: Vector2.LEFT,
	direction.UP: Vector2.UP,
	direction.DOWN: Vector2.DOWN
}


const bullet := preload("res://Scenes/Props/Bullet.tscn")


@export var phase := 0.0
@export var bullet_speed := 3000.0

@export var dir : direction = direction.RIGHT:
	set(d):
		dir = d
		$Sprite2D.flip_v = d == direction.LEFT
		match d:
			direction.RIGHT:
				rotation_degrees = 0
			direction.LEFT:
				rotation_degrees = 180
			direction.UP:
				rotation_degrees = -90
			direction.DOWN:
				rotation_degrees = 90

@export var interval := 1.0
var elapsed := interval * phase

func _ready():
	Shared.connect("bomb_explosion", _on_bomb_explode)

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	var _delta = delta
	
	if not Shared.is_in_zone(Rect2(position, $CollisionShape2D.shape.size)):
		_delta *= Shared.delta_scale
		
	elapsed += _delta
	
	if elapsed > interval:
		var i := bullet.instantiate()
		
		i.dir = movementVectors[dir]
		i.speed = bullet_speed
		
		add_child(i)
		
		elapsed = 0.0

func _on_bomb_explode(pos: Vector2):
	if pos.distance_squared_to(position) <= 128:
		queue_free()
