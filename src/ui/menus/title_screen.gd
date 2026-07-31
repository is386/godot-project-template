extends Control

@export var level_uid: String = ""

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	start_button.grab_focus()
	SignalBus.game_exited_to_menu.connect(_on_game_exited_to_menu)


func _on_game_exited_to_menu() -> void:
	show()
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	SignalBus.game_started.emit(level_uid, &"")


func _on_settings_button_pressed() -> void:
	SignalBus.settings_requested.emit(self)


func _on_close_button_pressed() -> void:
	SignalBus.game_close_requested.emit()
