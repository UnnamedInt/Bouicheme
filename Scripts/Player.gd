extends CharacterBody2D

@export var speed := 32
@export var gravity := 100

func _when_collides(can_hop = true):
	if not $RayCast2D.get_collider() is LevelMap:
		return
	
	var collider: LevelMap = $RayCast2D.get_collider()
	var point_to = Vector2(position.x + 8, position.y + 4)
	
	var cell = collider.get_cell_at(point_to)
	
	match cell:
		1, 8, 13:
			if can_hop:
				position += Vector2(1, -8)
				$RayCast2D.force_raycast_update()
				_when_collides(false)
			else:
				EBus.emit_signal("retry")
		32:
			$Key.play()
			EBus.emit_signal("goto_next")
		
func _physics_process(delta):
	var _delta = delta * EBus.delta_scale
	$AnimatedSprite2D.speed_scale = EBus.delta_scale
	
	if not is_on_floor():
		velocity.y += gravity * _delta
		velocity.x = 0
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
		
		$Steps.playing = false
		
		if position.y > 128:
			EBus.emit_signal("retry")
		
		move_and_slide()
		return
	
	velocity.x = speed * EBus.delta_scale
	$AnimatedSprite2D.play("default")
	
	if not $Steps.playing:
		$Steps.play()
		
	if $RayCast2D.is_colliding():
		_when_collides()
	
	move_and_slide()

func _on_bomb_explosion():
	EBus.emit_signal("retry")
