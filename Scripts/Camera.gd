extends Camera2D

@export var shaking := false
@export var shake_amplitude := 2
@export var duration := .5

var elapsed := .0

# Called when the node enters the scene tree for the first time.
func _ready():
	EBus.connect("retry", _on_shake_req)
	EBus.connect("bomb_explosion", _on_shake_req2)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("Fade")
		EBus.delta_scale = 0.5
		
	elif Input.is_action_just_released("ui_accept"):
		$AnimationPlayer.play_backwards("Fade")
		EBus.delta_scale = 1.0
	
	if not shaking or elapsed >= duration:
		return
	
	offset.x = randf_range(-shake_amplitude, shake_amplitude)
	offset.y = randf_range(-shake_amplitude, shake_amplitude)
	
	offset = offset.lerp(Vector2.ZERO, elapsed / duration)
	
	elapsed += delta
func _on_shake_req():
	shaking = true
	elapsed = .0
func _on_shake_req2(_pos):
	shaking = true
	elapsed = .0
	
