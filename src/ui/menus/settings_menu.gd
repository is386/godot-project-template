extends Control

@onready var fullscreen_toggle: CheckButton = %FullscreenToggle
@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SfxSlider
@onready var back_button: BaseButton = %BackButton

var _callback_control: Control = null


func _ready() -> void:
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_on_back_button_pressed)

	master_slider.value_changed.connect(AudioBus.set_master_volume)
	music_slider.value_changed.connect(AudioBus.set_music_volume)
	sfx_slider.value_changed.connect(AudioBus.set_sfx_volume)

	SignalBus.settings_requested.connect(_on_settings_requested)

	fullscreen_toggle.set_pressed_no_signal(_is_fullscreen())


func _on_settings_requested(callback_control: Control) -> void:
	_callback_control = callback_control
	if _callback_control != null:
		_callback_control.hide()

	show()


func _on_back_button_pressed() -> void:
	hide()

	if _callback_control == null:
		return

	_callback_control.show()
	_callback_control = null


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	var mode := DisplayServer.WINDOW_MODE_WINDOWED
	if toggled_on:
		mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

	DisplayServer.window_set_mode(mode)


func _is_fullscreen() -> bool:
	var mode := DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return true

	return mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
