extends TileMap
class_name LevelMap

const OFFSETS = [
	Vector2(-8, -8),
	Vector2(-8, 0),
	Vector2(-8, 8),
	Vector2(0, -8),
	Vector2(0, 0),
	Vector2(0, 8),
	Vector2(8, -8),
	Vector2(8, 0),
	Vector2(8, 8),
]

func _ready():
	EBus.connect("bomb_explosion", _bomb_explosion)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			destroy_cell(get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			add_cell(get_global_mouse_position())

func destroy_cell(mouse_pos: Vector2, override = false):
	var local_pos = local_to_map(mouse_pos)
	var value = get_cell_at(mouse_pos)
	
	if value & 1 == 0 and not override:
		return
	
	EBus.emit_signal("bloc_breakage")
	
	erase_cell(0, local_pos)
	
	if value & 4:
		set_cell(0, local_pos, 0, Vector2i(10, 1))
	

func add_cell(mouse_pos: Vector2):
	var value = get_cell_at(mouse_pos)
	
	if value & 2 == 0:
		return
		
	EBus.emit_signal("bloc_placement")
	
	set_cell(0, local_to_map(mouse_pos), 0, Vector2i(7, 5))

func get_cell_at(pos: Vector2) -> int:
	var local_pos = local_to_map(pos)
	var cell_data = get_cell_tile_data(0, local_pos)
	
	if cell_data == null:
		return 0
	
	return cell_data.get_custom_data("type")

func _bomb_explosion(pos: Vector2):
	for offset in OFFSETS:
		destroy_cell(pos + offset, true)
