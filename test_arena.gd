extends Node2D

@onready var game_tiles: TileMapLayer = $GameTiles
@onready var world_walls: StaticBody2D = $WorldWalls

var tile_ui: Node2D
var cached_bounds: Rect2

# Maps BaseTiles atlas coords → [game_source_id, alternative_id]
# Source 0 = SlimeTile, Source 1 = BasicTile (both use alternative 1)
const BASE_TO_GAME_TILE: Dictionary = {
	Vector2i(0, 0): [1, 1],  # BasicTile
	Vector2i(1, 0): [2, 1],  # StartTile
	Vector2i(2, 0): [1, 1],  # BasicTile
	Vector2i(0, 1): [1, 1],  # BasicTile
	Vector2i(1, 1): [0, 1],  # SlimeTile
	Vector2i(2, 1): [1, 1],  # BasicTile
	Vector2i(0, 2): [1, 1],  # BasicTile
	Vector2i(1, 2): [1, 1],  # BasicTile
	Vector2i(0, 3): [1, 1],  # BasicTile
	Vector2i(1, 3): [1, 1],  # BasicTile
}

func _ready() -> void:
	regenerate_walls()
	cached_bounds = get_tile_bounds()

	tile_ui = preload("res://UI/tile_ui.tscn").instantiate()
	add_child(tile_ui)
	tile_ui.visible = false
	tile_ui.card_selected.connect(_on_card_selected)

	_sync_tiles_from_base()
	_spawn_player_on_start_tile()
	Global.enemy_kill.connect(_on_enemy_killed)
	
func _sync_tiles_from_base() -> void:
	var base_tiles: TileMapLayer = tile_ui.get_node("TileMapUI/BaseTiles")
	var used = base_tiles.get_used_cells()
	if used.is_empty():
		return

	# Normalize so the top-left cell maps to (0, 0)
	var min_x = used[0].x
	var min_y = used[0].y
	for cell in used:
		min_x = min(min_x, cell.x)
		min_y = min(min_y, cell.y)
	var offset = Vector2i(min_x, min_y)

	game_tiles.clear()
	for cell in used:
		var atlas_coords: Vector2i = base_tiles.get_cell_atlas_coords(cell)
		var mapping: Array = BASE_TO_GAME_TILE.get(atlas_coords, [1, 1])
		game_tiles.set_cell(cell - offset, mapping[0], Vector2i(0, 0), mapping[1])

	regenerate_walls()
	cached_bounds = get_tile_bounds()

func _spawn_player_on_start_tile() -> void:
	for cell in game_tiles.get_used_cells():
		if game_tiles.get_cell_source_id(cell) == 2:
			$Player.global_position = tile_to_world(cell)
			return

func _on_enemy_killed() -> void:
	print("enemy killed")
	print(get_tree().get_nodes_in_group("enemy").size())
	if get_tree().get_nodes_in_group("enemy").size() - 1 == 0:
		print("show ui")
		show_tile_ui()

func show_tile_ui() -> void:
	var camera: Camera2D = $Player/Camera2D
	tile_ui.global_position = camera.global_position - Vector2(240, 135)
	tile_ui.show_ui()
	Global.freeze()

func _on_card_selected(_card_type: String) -> void:
	tile_ui.hide_ui()
	place_north_tile()
	Global.unfreeze()

func place_north_tile() -> void:
	var used = game_tiles.get_used_cells()
	if used.is_empty():
		return
	var top_cell = used[0]
	for cell in used:
		if cell.y < top_cell.y:
			top_cell = cell
	var north = top_cell + Vector2i(0, -1)
	# source 0 = TileSetScenesCollectionSource, scene key 1 = slime_tile.tscn
	game_tiles.set_cell(north, 0, Vector2i(0, 0), 1)
	regenerate_walls()
	cached_bounds = get_tile_bounds()

const HALF_TILE = 69.5

func regenerate_walls() -> void:
	for child in world_walls.get_children():
		child.queue_free()

	var used = game_tiles.get_used_cells()
	# Only non-basic tiles count as solid for wall purposes
	var solid_set = {}
	for cell in used:
		if game_tiles.get_cell_source_id(cell) != 1:
			solid_set[cell] = true

	for cell in solid_set:
		var world_pos = tile_to_world(cell)

		if not solid_set.has(cell + Vector2i(0, -1)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, -HALF_TILE),
							world_pos + Vector2(HALF_TILE, -HALF_TILE))
		if not solid_set.has(cell + Vector2i(0, 1)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, HALF_TILE),
							world_pos + Vector2(HALF_TILE, HALF_TILE))
		if not solid_set.has(cell + Vector2i(-1, 0)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, -HALF_TILE),
							world_pos + Vector2(-HALF_TILE, HALF_TILE))
		if not solid_set.has(cell + Vector2i(1, 0)):
			add_wall_segment(world_pos + Vector2(HALF_TILE, -HALF_TILE),
							world_pos + Vector2(HALF_TILE, HALF_TILE))

func add_wall_segment(a: Vector2, b: Vector2) -> void:
	var shape = SegmentShape2D.new()
	shape.a = a
	shape.b = b
	var col = CollisionShape2D.new()
	col.shape = shape
	world_walls.add_child(col)

func tile_to_world(tile_coords: Vector2i) -> Vector2:
	return game_tiles.to_global(game_tiles.map_to_local(tile_coords))

func get_tile_bounds() -> Rect2:
	var used = game_tiles.get_used_cells()
	if used.is_empty():
		return Rect2()

	var min_cell = Vector2i(used[0])
	var max_cell = Vector2i(used[0])

	for cell in used:
		min_cell.x = min(min_cell.x, cell.x)
		min_cell.y = min(min_cell.y, cell.y)
		max_cell.x = max(max_cell.x, cell.x)
		max_cell.y = max(max_cell.y, cell.y)

	var top_left = tile_to_world(min_cell) - Vector2(69.5, 69.5)
	var bottom_right = tile_to_world(max_cell) + Vector2(69.5, 69.5)

	return Rect2(top_left, bottom_right - top_left)
