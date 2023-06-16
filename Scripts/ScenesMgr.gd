extends Node

@onready var current: Node
@onready var level = 12

const LEVEL_MAX = 12

@onready var Game = get_parent().get_node("Game")

func _ready() -> void:
	Shared.connect("retry", _retry)
	Shared.connect("goto_next", _next)
	goto_level("res://Scenes/Levels/Level%d.tscn" % level)

func _retry():
	Shared.delta_scale = 1.0
	Shared.slow_time_left = 10.0
	goto_level("res://Scenes/Levels/Level%d.tscn" % level)

func _next():
	if not level >= LEVEL_MAX:
		level += 1
	
	_retry()

func goto(path: String) -> void:
	call_deferred("_goto_deferred", path)

func goto_level(path: String) -> void:
	call_deferred("_goto_level_deferred", path)

func _goto_deferred(path: String) -> void:
	if current != null:
		current.queue_free()
	current = load(path).instantiate()
	Game.add_child(current)

func _goto_level_deferred(path: String) -> void:
	if current != null:
		current.queue_free()
	current = load(path).instantiate()
	Game.add_child(current)
	Game.get_node("Player").position = Vector2(8, 0)
