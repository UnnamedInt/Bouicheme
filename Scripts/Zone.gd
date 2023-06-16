@tool

extends Node2D
class_name Zone

@export var size := Vector2(8, 8):
	set(s):
		size = s
		$LightOccluder2D.occluder.polygon = PackedVector2Array([
			-s/2,
			Vector2(s.x, -s.y)/2,
			Vector2(s.x, s.y)/2,
			Vector2(-s.x, s.y)/2
		])
		
		$LightOccluder2D.position = Vector2.ZERO

func _ready():
	if Engine.is_editor_hint():
		return
	
	Shared.zone_rects.append(Rect2(position-size/2, size))
