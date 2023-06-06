extends Node

@onready var current: Node
@onready var level = 0

const LEVEL_MAX = 5

func _ready() -> void:
	EBus.connect("retry", _retry)
	EBus.connect("goto_next", _next)
	goto("res://Scenes/Levels/Level0.tscn")

func _retry():
	goto("res://Scenes/Levels/Level%d.tscn" % level)

func _next():
	if not level >= LEVEL_MAX:
		level += 1
	
	_retry()

func goto(path: String) -> void:
	call_deferred("_goto_deferred", path)

func _goto_deferred(path: String) -> void:
	if current != null:
		current.queue_free()
	current = load(path).instantiate()
	get_parent().add_child(current)
	get_parent().get_node("Player").position = Vector2(8, 0)
