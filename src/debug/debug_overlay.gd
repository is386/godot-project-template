extends Control

const TOGGLE_KEY: Key = KEY_F3

const BUILD_PREFIX: String = "Build: "

@onready var content: MarginContainer = %MarginContainer
@onready var fps_label: Label = %FpsLabel
@onready var version_info: Label = %VersionInfo
@onready var project_name: Label = %ProjectName


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return

	_add_version_to_info_label()
	_add_project_name_to_label()


func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return

	if key_event.keycode == TOGGLE_KEY:
		content.visible = not content.visible
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if not content.visible:
		return

	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))


func _add_version_to_info_label() -> void:
	var version_str: String = ProjectSettings.get_setting("application/config/version", "")
	version_info.text = BUILD_PREFIX + version_str


func _add_project_name_to_label() -> void:
	project_name.text = ProjectSettings.get_setting("application/config/name", "")
