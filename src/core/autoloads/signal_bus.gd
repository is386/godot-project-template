extends Node

@warning_ignore_start("unused_signal")

signal game_started(level_uid: String, spawn_id: StringName)
signal quit_requested
signal level_unloading(level: BaseLevel)
signal level_loaded(level: BaseLevel)
