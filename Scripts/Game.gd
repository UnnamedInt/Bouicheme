extends Node2D

var slow_time := 10.0

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Camera2D/AnimationPlayer.play("Fade")
		Shared.delta_scale = 0.5
		
	elif Input.is_action_just_released("ui_accept") or Shared.slow_time_left <= 0.0:
		$Camera2D/AnimationPlayer.play_backwards("Fade")
		Shared.delta_scale = 1.0
	
	if Shared.slow_time_left >= slow_time:
		$GameUI/ProgressBar.hide()
	else:
		$GameUI/ProgressBar.show()
		var val = 100 * Shared.slow_time_left / slow_time
		Shared.slow_time_left -= delta
		
		$GameUI/ProgressBar.value = val
	
	if Shared.delta_scale >= 1:
		Shared.slow_time_left = min(Shared.slow_time_left + delta * 2, slow_time)
	else:
		Shared.slow_time_left -= delta
