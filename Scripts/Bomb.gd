extends CharacterBody2D
class_name Bomb

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity := 100

var mouse_over := false
var locked := false

func _input(event):
	if not (event is InputEventMouseButton and event.is_pressed()):
		return
		
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	var pos := to_local(get_global_mouse_position())
	var shape : RectangleShape2D = $CollisionShape2D.shape
	
	if shape.get_rect().has_point(pos):
		_ignite()

func _physics_process(delta):	
	var _scale := 1.0 \
		if Shared.is_in_zone(Rect2(position, Vector2(8, 8))) \
		else Shared.delta_scale
	
	if not is_on_floor():
		velocity.y += gravity * delta * _scale

	move_and_slide()

func _ignite():
	if locked:
		return
	
	locked = true
	
	$Ignited.emitting = true
	$Ignition.play()
	await get_tree().create_timer(1).timeout
	Shared.emit_signal("bomb_explosion", position)
	
	$Pop.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func _on_audio_stream_player_finished():
	queue_free()
