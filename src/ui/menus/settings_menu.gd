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

	fullscreen_toggle.visible = _can_change_window_mode()
	fullscreen_toggle.set_pressed_no_signal(_is_fullscreen())

	visibility_changed.connect(_on_visibility_changed)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()
		get_viewport().set_input_as_handled()


func _on_visibility_changed() -> void:
	if visible and is_inside_tree():
		_focus_first_control()


func _focus_first_control() -> void:
	for control: Control in [fullscreen_toggle, master_slider, back_button]:
		if control.visible:
			control.grab_focus()
			return


func _on_settings_requested(callback_control: Control) -> void:
	_callback_control = callback_control
	if _callback_control != null:
		_callback_control.hide()

	fullscreen_toggle.set_pressed_no_signal(_is_fullscreen())

	show()


func _on_back_button_pressed() -> void:
	hide()

	if _callback_control == null:
		return

	_callback_control.show()
	_callback_control = null


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	var mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED
	if toggled_on:
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN

	DisplayServer.window_set_mode(mode)


func _can_change_window_mode() -> bool:
	return not OS.has_feature("mobile")


func _is_fullscreen() -> bool:
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return true

	return mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
