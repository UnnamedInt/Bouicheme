extends CharacterBody2D
class_name Player

@export var speed := 32
@export var gravity := 100

func _when_collides(can_hop = true):
	if $RayCast2D.get_collider() is Canon:
		if can_hop:
			position += Vector2(1, -6)
			$RayCast2D.force_raycast_update()
			_when_collides(false)
		else:
			Shared.emit_signal("retry")
			Shared.deathcount += 1
		
	if not $RayCast2D.get_collider() is LevelMap:
		return
	
	var collider: LevelMap = $RayCast2D.get_collider()
	var above := Vector2(position.x, position.y - 4)
	var point_to := Vector2(position.x + 8, position.y + 4)
	
	var cell := collider.get_cell_at(point_to)
	var above_cell := collider.get_cell_at(above)
	
	match cell:
		1, 8, 13:
			if can_hop and [0, 2, 8].has(above_cell):
				position += Vector2(1, -8)
				$RayCast2D.force_raycast_update()
				_when_collides(false)
			else:
				Shared.emit_signal("retry")
				Shared.deathcount += 1

func _physics_process(delta):
	if Input.is_action_just_pressed("retry"):
		Shared.emit_signal("retry")
		Shared.deathcount += 1
	
	Shared.player_pos = position
	
	var _delta = delta * Shared.delta_scale
	$AnimatedSprite2D.speed_scale = Shared.delta_scale
	
	if Shared.delta_scale < 1:
		$AnimatedSprite2D/Trail2D.show()
	else:
		$AnimatedSprite2D/Trail2D.hide()
		$AnimatedSprite2D/Trail2D.clear_points()
	
	if not is_on_floor():
		velocity.y += gravity * _delta
		velocity.x = 0
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
		
		$Steps.playing = false
		
		if position.y > 128:
			Shared.emit_signal("retry")
			Shared.deathcount += 1
		
		move_and_slide()
		return
	
	velocity.x = speed * Shared.delta_scale
	$AnimatedSprite2D.play("default")
	
	if not $Steps.playing:
		$Steps.play()
		
	if $RayCast2D.is_colliding():
		_when_collides()
	
	move_and_slide()
