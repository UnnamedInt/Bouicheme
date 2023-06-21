extends Node

signal game_over
signal retry
signal goto_next

signal bomb_explosion(pos: Vector2)

signal bloc_placement
signal bloc_breakage

var delta_scale := 1.0
var zone_rects : Array[Rect2] = []

var slow_time_left := 10.0
var player_pos := Vector2.ZERO

var deathcount := 0
var finished := false
var deathless := false

func is_in_zone(rect: Rect2):
	for i in zone_rects:
		if i.intersects(rect, true):
			return true
	return false
