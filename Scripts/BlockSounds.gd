extends AudioStreamPlayer

func _ready():
	Shared.connect("bloc_placement", _on_bloc_placement)
	Shared.connect("bloc_breakage", _on_bloc_breakage)

func _on_bloc_placement():
	pitch_scale = .75
	play()

func _on_bloc_breakage():
	pitch_scale = .5
	play()
