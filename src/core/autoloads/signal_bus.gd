extends Node

@warning_ignore_start("unused_signal")

signal game_started(level_uid: String, spawn_id: StringName)
signal game_exit_to_title_requested
signal game_exited_to_menu
signal game_close_requested
signal game_pause_requested
signal game_paused
signal game_resume_requested
signal game_resumed

signal level_unloading(level: BaseLevel)
signal level_loaded(level: BaseLevel)
