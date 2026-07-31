extends Control

@export var new_game_level_uid: String = ""

@onready var start_button: Button = %StartButton
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	SignalBus.game_started.emit(new_game_level_uid, &"")


func _on_exit_button_pressed() -> void:
	SignalBus.quit_requested.emit()
