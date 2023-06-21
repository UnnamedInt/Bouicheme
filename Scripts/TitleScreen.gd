extends Control

func _ready():
	if Shared.deathless:
		$Label2.text = "Thanks For Playing :)"
		$Label2.show()
	elif Shared.finished:
		$Label2.show()

func _on_button_pressed():
	if Shared.finished:
		Shared.deathless = true
	Shared.emit_signal("retry")
