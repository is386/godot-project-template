class_name MainGame
extends Node

const PLAYER_SCENE_UID: String = "uid://bk2cu2ameptuy"

var player: Player = null

# Managers
@onready var level_manager: LevelManager = %LevelManager

# Game World root nodes
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

# UI Root Nodes
@onready var hud_root: Control = %HudRoot
@onready var menu_root: Control = %MenuRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot


func _ready() -> void:
	SignalBus.game_started.connect(_on_game_started)
	SignalBus.quit_requested.connect(_quit_game)


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if event.is_action_pressed("debug_quit"):
		_quit_game()


func _on_game_started(level_uid: String, spawn_id: StringName) -> void:
	if level_uid.is_empty():
		push_error("Cannot start the game without a level")
		return

	_hide_menus()
	_init_player()
	load_level(level_uid, spawn_id)


func _hide_menus() -> void:
	for menu: Node in menu_root.get_children():
		if menu is CanvasItem:
			(menu as CanvasItem).hide()


func load_level(level_scene: String, spawn_id: StringName = &"") -> BaseLevel:
	var level: BaseLevel = await level_manager.load_level(level_scene)
	if level == null:
		return null

	_place_player_at_level_spawn(spawn_id)

	SignalBus.level_loaded.emit(level)
	return level


func _init_player() -> void:
	if player != null:
		return

	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return

	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
		return

	entity_root.add_child(player)


func _place_player_at_level_spawn(spawn_id: StringName) -> void:
	if player == null:
		return
	if level_manager.current_level == null:
		push_error("Cannot place player into level because level is null")
		return

	player.global_position = level_manager.current_level.get_spawn_point(spawn_id)


func _quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
