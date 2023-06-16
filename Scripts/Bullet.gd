class_name Bullet
extends CharacterBody2D

@export var speed := 32
@export var dir := Vector2.RIGHT

func _physics_process(delta):
	
	# Add the gravity.
	velocity = dir * speed * delta
	
	if not Shared.is_in_zone(
		Rect2(get_parent().to_global(position-Vector2(4,4)), Vector2(8, 8) * dir).abs()
	):
		velocity *= Shared.delta_scale

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		
		if col.get_collider() is Canon:
			return
			
		if col.get_collider() is Player:
			Shared.emit_signal("retry")
		
		if col.get_normal().abs() == dir.abs():
			queue_free()
	
	if not Rect2(Vector2.ZERO, Vector2(256, 128)) \
			.has_point(get_parent().to_global(position)):
		queue_free()
