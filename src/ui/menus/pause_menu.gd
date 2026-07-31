extends Control

@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var exit_to_menu_button: Button = %ExitToMenuButton


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_to_menu_button.pressed.connect(_on_exit_to_menu_button_pressed)

	SignalBus.game_paused.connect(_on_game_paused)
	SignalBus.game_resumed.connect(hide)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("pause"):
		SignalBus.game_resume_requested.emit()
		get_viewport().set_input_as_handled()


func _on_game_paused() -> void:
	show()
	resume_button.grab_focus()


func _on_resume_button_pressed() -> void:
	SignalBus.game_resume_requested.emit()


func _on_settings_button_pressed() -> void:
	SignalBus.settings_requested.emit(self)


func _on_exit_to_menu_button_pressed() -> void:
	SignalBus.game_exit_to_title_requested.emit()
