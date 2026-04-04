extends Node2D
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var base_floor: TileMapLayer = $BaseFloor
var clickable
@onready var camera: Camera2D = $Player/Camera2D
@onready var ghost_floor: TileMapLayer = $GhostFloor
var can_interact = false
var mouse_pos
var pattern
@onready var game_tiles: TileMapLayer = $GameTiles

@export var slime_scene : PackedScene

var cached_bounds
@onready var world_walls: StaticBody2D = $WorldWalls
var placed_tiles: Dictionary  # Vector2i -> Node

func _ready() -> void:
	regenerate_walls()
	cached_bounds = get_tile_bounds()
	enemy_spawner.spawn_enemies(slime_scene, 1)
	
const HALF_TILE = 69.5

func regenerate_walls() -> void:
	# Clear all existing wall segments
	for child in world_walls.get_children():
		child.queue_free()

	var used = game_tiles.get_used_cells()
	var used_set = {}
	for cell in used:
		used_set[cell] = true

	for cell in used:
		var world_pos = tile_to_world(cell)

		if not used_set.has(cell + Vector2i(0, -1)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, -HALF_TILE), 
							world_pos + Vector2(HALF_TILE, -HALF_TILE))
		if not used_set.has(cell + Vector2i(0, 1)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, HALF_TILE), 
							world_pos + Vector2(HALF_TILE, HALF_TILE))
		if not used_set.has(cell + Vector2i(-1, 0)):
			add_wall_segment(world_pos + Vector2(-HALF_TILE, -HALF_TILE), 
					world_pos + Vector2(-HALF_TILE, HALF_TILE))
		if not used_set.has(cell + Vector2i(1, 0)):
			add_wall_segment(world_pos + Vector2(HALF_TILE, -HALF_TILE), 
							world_pos + Vector2(HALF_TILE, HALF_TILE))

func add_wall_segment(a: Vector2, b: Vector2) -> void:
	var shape = SegmentShape2D.new()
	shape.a = a
	shape.b = b
	var col = CollisionShape2D.new()
	col.shape = shape
	world_walls.add_child(col)
	
	
# Convert a world position to tile coords on game_tiles
func world_to_tile(world_pos: Vector2) -> Vector2i:
	return game_tiles.local_to_map(game_tiles.to_local(world_pos))

# Convert tile coords back to a world position (cell center)
func tile_to_world(tile_coords: Vector2i) -> Vector2:
	return game_tiles.to_global(game_tiles.map_to_local(tile_coords))
	
const DIRECTIONS = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]

func get_adjacent_empty_cells() -> Array:
	var occupied = game_tiles.get_used_cells()
	var occupied_set = {}
	for cell in occupied:
		occupied_set[cell] = true

	var candidates = {}
	for cell in occupied:
		for dir in DIRECTIONS:
			var neighbour = cell + dir
			if not occupied_set.has(neighbour):
				candidates[neighbour] = true

	return candidates.keys()
	
func place_tile(cell: Vector2i, source_id: int, atlas_coords: Vector2i, alternative_id: int) -> void:
	# Also track it logically in the tilemap
	game_tiles.set_cell(cell, 0, Vector2i(0, 0), 1)

	regenerate_walls()
	cached_bounds = get_tile_bounds()
	print("Placed tile at: ", cell)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			var empty_adjacent = get_adjacent_empty_cells()
			if empty_adjacent.is_empty():
				print("No adjacent cells available")
				return
			var target_cell = empty_adjacent[randi() % empty_adjacent.size()]
			place_tile(target_cell, 0, Vector2i(0, 0), 1)
			print("Placed tile at: ", target_cell)
			

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
	
func get_tile_node_at(cell: Vector2i) -> Node:
	return placed_tiles.get(cell, null)
			
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_I:
			#var used = game_tiles.get_usedo_cells()
			#if used.is_empty():
				#print("game_tiles empty")
				#return
			#var first = used[0]
			#print("source_id: ", game_tiles.get_cell_source_id(first))
			#print("atlas_coords: ", game_tiles.get_cell_atlas_coords(first))
			#print("alternative: ", game_tiles.get_cell_alternative_tile(first))

#func _ready():
	#clickable = base_floor.get_used_cells()
	#print(clickable)
	#pattern = ghost_floor.tile_set.get_pattern(0)
	#
	#enemy_spawner.spawn_enemies(4)
	
#func _process(delta: float) -> void:
	#var local_pos = base_floor.to_local(camera.get_global_mouse_position())
	#mouse_pos = base_floor.local_to_map(local_pos)
	#if clickable:
		#for x in clickable:
			#if (mouse_pos == x):
				#can_interact = true
			#else:
				#can_interact = false
					#
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_released("interact") && can_interact == true:
		#print("set pattern")
		#ghost_floor.set_pattern(mouse_pos, pattern)
