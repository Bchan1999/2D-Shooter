# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Godot 4.5 2D top-down shooter. Viewport: 480×270 (scaled to 1920×1080). Pixel art rendering (nearest-neighbor filter). Mobile renderer.

## Running the Game

Open in Godot 4.5 and press F5 (run main scene) or F6 (run current scene). There is no CLI build/test system — all iteration happens inside the Godot editor.

Main scene entry point: `res://Scripts/Global/scene_manager.gd` (autoload, holds a Player node and manages scene swapping).

Current main scene is TestArena `res://test_arena.tscn`

## Autoloads (Singletons)

| Name | Path | Purpose |
|---|---|---|
| `Global` | `Scripts/Global/global.gd` | Enums (`enemy`, `scene`, `npc`), global signals (`freeze_game`, `enemy_kill`, `npc_interact`, `dialogue`), `is_game_frozen` state |
| `SceneManager` | `Scripts/Global/scene_manager.gd` | `add_scene(PackedScene)` / `remove_scene(NodePath)` for swapping floors/hub; holds the Player node |
| `InteractionManager` | `Interaction/InteractionManager.tscn` | Tracks `InteractionArea` nodes near the player, shows E-popup, dispatches `interact` on key press |
| `DialogueManager` | `addons/dialogue_manager/dialogue_manager.gd` | Third-party Dialogue Manager plugin |

## Architecture

### State Machine (enemies)
`Scripts/Util/State.gd` — base class with `Enter()`, `Exit()`, `Update(delta)`, `Physics_Update(delta)`, and a `Transitioned` signal.  
`Scripts/Util/state_machine.gd` — generic driver; child `State` nodes are auto-registered by name; call `Transitioned.emit(self, "state_name")` from a state to transition.

`SlimeEnemy` (`Scripts/Enemy/SlimeEnemy/slime_enemy.gd`) uses a **manual** state machine (not the generic one) driven by `Global.enemy` enum values (IDLE, HURT, DEATH, CHASE, SPAWN). States live as child nodes under the enemy scene.

### Player
`Scripts/Player/player.gd` — `CharacterBody2D`. WASD movement with acceleration/deceleration. Aim is a `Marker2D` that lerps toward the mouse; 8-directional gun animation is selected by `aim.rotation_degrees` ranges. Shooting instantiates `bullet_scene` at `aim/bullet_hole` and adds it to the current scene root.

Movement is blocked when `Global.is_game_frozen` is true (player connects to `Global.freeze_game` signal).

### Interaction System
`Interaction/Interaction_Area/` — `InteractionArea` nodes call `InteractionManager.register_area(self)` / `unregister_area(self)` on enter/exit. The manager sorts by distance to player and shows the E-popup above the closest area. On `interact` input it `await`s `active_areas[0].interact.call()`.

### Tile Arena (in-progress)
`test_arena.gd` — dynamic tile placement system. `game_tiles` (TileMapLayer) tracks placed tiles; `regenerate_walls()` rebuilds `StaticBody2D` collision segments from exposed tile edges after every placement. Press **T** to place a tile on a random adjacent empty cell.

### Enemy Spawner
`Scripts/enemy_spawner.gd` (`EnemySpawner` class) — attach as child of any scene; child `Marker2D` nodes are used as spawn points. Call `spawn_enemies(scene, amount)` from the parent.

## Input Map

| Action | Binding |
|---|---|
| `left/right/up/down` | WASD |
| `shoot` | Left mouse button |
| `interact` | E |

## Dialogue

`.dialogue` files live in `Dialogue/`. Managed by the Dialogue Manager plugin. Dialogue pauses the game via `Global.freeze()` / `Global.unfreeze()`.

## Groups

`bullet`, `enemy`, `player`, `diamond` — used for collision filtering and `is_in_group()` checks throughout the codebase.
